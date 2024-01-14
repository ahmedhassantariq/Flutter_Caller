importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyCxCu95uYj0eMTC8QuzpiKRKjmx6SELPJY",
    authDomain: "called-778ca.firebaseapp.com",
    projectId: "called-778ca",
    storageBucket: "called-778ca.appspot.com",
    messagingSenderId: "765260589155",
    appId: "1:765260589155:web:a17f7961a6fca4cc1f7056",
    measurementId: "G-G475KGE701"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});