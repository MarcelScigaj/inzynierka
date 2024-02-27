import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'
import axios from 'axios';

import PrimeVue from 'primevue/config';
import ToastService from 'primevue/toastservice';
import Toast from 'primevue/toast';


import 'primevue/resources/themes/saga-blue/theme.css'; // lub inny wybrany temat

import 'primeicons/primeicons.css'; // Ikony PrimeVue
import 'primevue/resources/primevue.min.css';


import VCalendar from 'v-calendar';
import 'v-calendar/style.css';


//import 'vue-advanced-chat/dist/vue-advanced-chat.css'

const app = createApp(App)

app.use(router);
app.use(PrimeVue, { ripple: true });
app.use(ToastService);
app.use(VCalendar, {});

app.component('Toast', Toast);

axios.defaults.withCredentials = true;

//axios.defaults.baseURL = import.meta.env.VITE_API_URL;


// Dodanie interceptora żądań do Axios
axios.interceptors.request.use(function (config) {
    // Pobranie tokena z localStorage
    const token = localStorage.getItem('authToken');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
});

axios.interceptors.response.use(response => {
  // Przepuść przez interceptor każdą odpowiedź, która nie jest błędem
  return response;
}, error => {
  // Obsługa błędu 401 (brak autoryzacji)
  if (error.response && error.response.status === 401) {
      localStorage.removeItem('authToken');
      localStorage.removeItem('userData');
      localStorage.removeItem('userRole');
      router.push('/login');
      app.config.globalProperties.$toast.add({severity:'error', summary: 'Błąd logowania', detail: 'Sesja wygasła lub użytkownik nie jest zalogowany.', life: 3000});
  }
  // Obsługa błędu 403 (brak uprawnień)
  else if (error.response && error.response.status === 403) {
      // Przekierowanie na stronę główną
      router.push('/home');
      // Wyświetlenie komunikatu o braku uprawnień
      app.config.globalProperties.$toast.add({severity:'warn', summary: 'Brak uprawnień', detail: 'Nie masz uprawnień do wykonania tej operacji.', life: 3000});
  }
  return Promise.reject(error);
});

app.mount('#app');
