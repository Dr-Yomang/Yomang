const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnDocumentChange = functions.firestore.document('HistoryDebugCollection/{documentId}')
    .onCreate((snap, context) => {
        const createdData = snap.val();

        sendNotification(createdData);
        return null;
    });

function sendNotification(createdData) {
    let db = admin.firestore();
    db.collection('UserDebugCollection').where('uid', '==', createdData.senderUid).get()
        .then((snapshot) => {
            let senderData = snapshot.docs[0];
            let senderUsername = senderData.get('username');
            const registrationToken = senderData.get('partnerToken');

            const message = {
                notification: {
                    title: '요망 Yomang',
                    body: `${senderUsername}에게서 새로운 요망이 도착했어요!`
                },
                token: registrationToken
            };

            admin.messaging().send(message)
                .then((response) => {
                    console.log('알림이 성공적으로 보내졌습니다:', response);
                })
                .catch((error) => {
                    console.log('알림 보내기에 실패했습니다:', error);
                });
        })
        .catch((err) => {
            console.log('발신자 정보를 읽어오기에 실패했습니다:', err);
    });
}
