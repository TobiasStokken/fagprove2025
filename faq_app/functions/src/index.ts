import { onCall } from "firebase-functions/v2/https";
import { initializeApp } from "firebase-admin/app";
import { getFirestore, Timestamp } from "firebase-admin/firestore";

initializeApp();
const db = getFirestore();

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

async function checkIsAdmin(uid: string): Promise<boolean> {
  const adminDoc = await db.collection("admin").doc(uid).get();
  return adminDoc.exists;
}
