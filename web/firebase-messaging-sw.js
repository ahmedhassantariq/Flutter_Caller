importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'AIzaSyCxCu95uYj0eMTC8QuzpiKRKjmx6SELPJY',
    appId: '1:765260589155:web:a17f7961a6fca4cc1f7056',
    messagingSenderId: '765260589155',
    projectId: 'called-778ca',
    authDomain: 'called-778ca.firebaseapp.com',
    storageBucket: 'called-778ca.appspot.com',

});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});