import { createRouter, createWebHistory } from 'vue-router';
import Home from './components/Home.vue';
import Login from './components/Login.vue';
import Register from './components/Register.vue';
import ProfileUpdate from './components/ProfileUpdate.vue';
import CreateExercise from './components/CreateExercise.vue';
import ExerciseList from './components/ExerciseList.vue';
import PlanCreator from './components/PlanCreator.vue';
import CreateTrainerAccount from './components/CreateTrainerAccount.vue';
import TreningForm from './components/TreningForm.vue';
import TreningList from './components/TreningList.vue';
import GroupSelection from './components/GroupSelection.vue';
import ChatView from './components/ChatView.vue'
import Start from './components/Start.vue'



const routes = [

  //Stworzyc komponent startowa!!!
  { path: '/', redirect: '/start' },
  { path: '/start', component: Start },
  { path: '/home', component: Home,meta: { requiresAuth: true } },
  { path: '/login', component: Login },
  { path: '/register', component: Register , meta: { requiresAuth: true, allowedRoles: ['Trener'] } },
  { path: '/profile-update', component: ProfileUpdate ,meta: { requiresAuth: true }},
  { path: '/createExercise', component: CreateExercise ,  meta: { requiresAuth: true, allowedRoles: ['Trener'] } },
  { path: '/exerciselist', component: ExerciseList ,meta: { requiresAuth: true }},
  { path: '/plancreator', component: PlanCreator , meta: { requiresAuth: true, allowedRoles: ['Trener'] } },
  { path: '/createtrainer', component: CreateTrainerAccount , meta: { requiresAuth: true, allowedRoles: ['Admin'] }},
  { path: '/treningform/:grupaTreningowaId', name: 'TreningForm', component: TreningForm, props: true,  meta: { requiresAuth: true, allowedRoles: ['Trener'] } },
  { path: '/treninglist', component: TreningList, meta: { requiresAuth: true , allowedRoles: ['Trener']}},
  { path: '/groupselection', component: GroupSelection, meta: { requiresAuth: true, allowedRoles: ['Trener'] }},
  { path: '/chat', component:ChatView},
];


const router = createRouter({
  history: createWebHistory(),
  routes,
});


  router.beforeEach((to, from, next) => {
  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
  const allowedRoles = to.meta.allowedRoles || [];
  const isAuthenticated = !!localStorage.getItem('authToken');
  const userRoles = JSON.parse(localStorage.getItem('userRole')) || [];

  if (!isAuthenticated && to.path === '/home') {
    // Niezalogowani użytkownicy próbujący dostać się do /home są przekierowywani na /start
    next('/start');
  } else if (requiresAuth && !isAuthenticated) {
    // Użytkownik nie jest zalogowany i próbuje dostać się do strony wymagającej autentykacji
    next('/login');
  } else if (isAuthenticated && to.path === '/login') {
    // Zalogowany użytkownik próbuje dostać się do strony logowania
    next('/home');
  } else if (requiresAuth && isAuthenticated && allowedRoles.length && !allowedRoles.some(role => userRoles.includes(role))) {
    // Użytkownik jest zalogowany, ale nie ma wymaganej roli
    next('/home'); // lub dowolna inna strona, na którą chcesz przekierować użytkownika
  } else {
    // Wszystkie inne przypadki
    next();
  }
});

export default router;
