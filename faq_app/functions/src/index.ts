import { onCall } from "firebase-functions/v2/https";
import { initializeApp } from "firebase-admin/app";
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { genkit } from "genkit";
import { gemini15Flash,  googleAI } from "@genkit-ai/googleai";
import { logger } from "firebase-functions";
import { defineSecret } from "firebase-functions/params";

initializeApp();
const db = getFirestore();

const ai = genkit({
  plugins: [googleAI()],
  model: gemini15Flash,
});
const geminiApiKey = defineSecret("GEMINI_API_KEY");

export const createNewFAQ = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new Error("Unauthorized: No user ID found.");
  }
  
  if (!(await checkIsAdmin(uid))) {
    throw new Error("Unauthorized: User is not an admin.");
  }
  await db.collection("faq").doc().create({
    title: request.data.title,
    description: request.data.description,
    createdAt: Timestamp.now(),
  });
});

export const editFAQ = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new Error("Unauthorized: No user ID found.");
  }
  if (!(await checkIsAdmin(uid))) {
    throw new Error("Unauthorized: User is not an admin.");
  }
  const faqId = request.data.faqId;
  if (!faqId) {
    throw new Error("Invalid request: FAQ ID is required.");
  }
  const faqData = {
    title: request.data.title,
    description: request.data.description,
    updatedAt: Timestamp.now(),
  };
  await db.collection("faq").doc(faqId).set(faqData, { merge: true });
  return { success: true, message: "FAQ updated successfully." };
});

export const createQuestion = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new Error("Unauthorized: No user ID found.");
  }

  if (!(await checkIsAdmin(uid))) {
    throw new Error("Unauthorized: User is not an admin.");
  }

  const faqId = request.data.faqId;
  if (!faqId) {
    throw new Error("Invalid request: FAQ ID is required.");
  }
  
  const questionData = {
    question: request.data.question,
    answer: request.data.answer,
    createdAt: Timestamp.now(),
  };
  
  await db.collection("faq").doc(faqId).collection("questions").doc().set(questionData);
  return { success: true, message: "Question created successfully." };
});

export const editQuestion = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new Error("Unauthorized: No user ID found.");
  }
  if (!(await checkIsAdmin(uid))) {
    throw new Error("Unauthorized: User is not an admin.");
  }
  const faqId = request.data.faqId;
  if (!faqId) {
    throw new Error("Invalid request: FAQ ID is required.");
  }
  const questionId = request.data.questionId;
  if (!questionId) {
    throw new Error("Invalid request: Question ID is required.");
  }
  const questionData = {
    question: request.data.question,
    answer: request.data.answer,
    updatedAt: Timestamp.now(),
  };
  await db.collection("faq").doc(faqId).collection("questions").doc(questionId).set(questionData, { merge: true });
  return { success: true, message: "Question updated successfully." };
});

export const deleteFAQ = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new Error("Unauthorized: No user ID found.");
  }

  if (!(await checkIsAdmin(uid))) {
    throw new Error("Unauthorized: User is not an admin.");
  }

  const faqId = request.data.faqId;
  if (!faqId) {
    throw new Error("Invalid request: FAQ ID is required.");
  }

  await db.collection("faq").doc(faqId).delete();
});

export const deleteQuestion = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new Error("Unauthorized: No user ID found.");
  }

  if (!(await checkIsAdmin(uid))) {
    throw new Error("Unauthorized: User is not an admin.");
  }

  const faqId = request.data.faqId;
  if (!faqId) {
    throw new Error("Invalid request: FAQ ID is required.");
  }
  const questionId = request.data.questionId;
  if (!questionId) {
    throw new Error("Invalid request: Question ID is required.");
  }

  await db.collection("faq").doc(faqId).collection("questions").doc(questionId).delete();
});

async function checkIsAdmin(uid: string): Promise<boolean> {
  const adminDoc = await db.collection("admin").doc(uid).get();
  return adminDoc.exists;
}


export const askAi = onCall(
  { secrets: [geminiApiKey] },
  async (request) => {
    logger.info("askAi called", { auth: request.auth, data: request.data });
    const uid = request.auth?.uid;
    if (!uid) {
      logger.error("Unauthorized: No user ID found.");
      throw new Error("Unauthorized: No user ID found.");
    }

    const question = request.data.question;
    if (!question) {
      logger.error("Invalid request: Question is required.");
      throw new Error("Invalid request: Question is required.");
    }

    try {
      // Definer FAQData-type
      type FAQData = {
        id: string;
        title?: string;
        description?: string;
        questions?: { question: string; answer: string }[];
      };
      
      // Hent alle FAQ-data fra Firestore
      const faqSnapshot = await db.collection("faq").get();
      const faqData: FAQData[] = faqSnapshot.docs.map(doc => ({ id: doc.id, ...(doc.data() as Omit<FAQData, "id">) }));
      logger.info("Fetched FAQ data", { data: faqData });

      // Formater FAQ-data for bedre kontekst
      const faqs = await Promise.all(faqData.map(async faq =>  {
        const tema = `Tema: ${faq.title || ""}`;
        const beskrivelse = faq.description ? `\nBeskrivelse: ${faq.description}` : "";
        const faqQuestions = await db.collection("faq").doc(faq.id).collection("questions").get();
        const qas = faqQuestions.docs.map((q) => {
          const data = q.data() as { answer?: string; question?: string };
          return `- Spørsmål: ${data.question || ""}\n  Svar: ${data.answer || ""}`;
        }).join("\n");
        return `${tema}${beskrivelse}\nSpørsmål og svar:\n${qas}`;
      }));

      const formattedFaq = faqs.join("\n\n");


      logger.info("Formatted FAQ data for AI prompt", { formattedFaq });

      // Lag en bedre prompt for FAQ-app
      const prompt = `Du er en hjelpsom FAQ-assistent for en app. Bruk følgende FAQ-data for å svare på brukerens spørsmål. Svar tydelig og kortfattet, og referer til relevante temaer hvis mulig.\n\nFAQ-data:\n${formattedFaq}\n\nBrukers spørsmål: ${question}`;

      logger.info("Sending improved prompt to Genkit AI", { prompt });
      const { text } = await ai.generate({ prompt });
      logger.info("Genkit AI response", { text });
      return {
        answer: text || "No answer generated.",
        timestamp: Timestamp.now(),
      };
    } catch (error) {
      const err = error as Error;
      logger.error("Error in Genkit AI call", { error: err.toString(), stack: err.stack });
      throw new Error("AI service failed.");
    }
  }
);