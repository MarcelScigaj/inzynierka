import './bootstrap';
import '../css/app.css'; 
import { createApp } from 'vue';
import router from './router';
import App from './App.vue';


// Tworzenie instancji Vue
const app = createApp(App);


// Użycie Vue Router
app.use(router);

// Montowanie aplikacji
app.mount('#app');
