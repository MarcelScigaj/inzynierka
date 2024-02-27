<template>
  <div>
    <Toast/>
    
    
    <header class="top-bar">
      <div class="login-section">
        <button v-if="!isLoggedIn" @click="navigateToLogin">Zaloguj</button>
        <div v-else class="user-info">
          <span @click="toggleDropdown">Cześć, {{ userName }}</span>
          <div v-if="showDropdown" class="dropdown-content">
            <a @click="navigateToProfile">Profil</a>
            <a @click="logout">Wyloguj</a>
          </div>
        </div>
      </div>
    </header>

    
    <nav class="navigation-bar">
      <ul>
        <li v-for="route in visibleRoutes" :key="route.name" class="with-dropdown">
          <a @click="navigateTo(route.path)">{{ route.name }}</a>
          <ul v-if="route.children">
            <li v-for="child in route.children" :key="child.name">
              <a @click="navigateTo(child.path)">{{ child.name }}</a>
            </li>
          </ul>
        </li>
      </ul>
    </nav>

    <div class="content-wrapper">
      <router-view @logged-in="onLoggedIn"></router-view>
    </div>
  </div>
</template>

<script>
import axios from 'axios';



export default {
  name: 'App',


  data() {
    return {
      routes: [
        { name: 'Strona główna', path: '/home' },
        { name: 'Trening', path: '#', children: [
          { name: 'Stwórz trening', path: '/groupselection' },
          { name: 'Lista treningów', path: '/treninglist' }
        ]},
        { name: 'Ćwiczenie', path: '#', children: [
          { name: 'Stwórz ćwiczenie', path: '/createexercise' },
          { name: 'Lista ćwiczeń', path: '/exerciselist' }
        ]},
        { name: 'Zarejestruj zawodnika', path: '/register' },
        { name: 'Stwórz plan', path: '/plancreator' },
        { name: 'Rejestruj trenera', path: '/createtrainer' },
        // Dodaj więcej ścieżek zgodnie z wymaganiami
      ],
      userRole: null,
      highlightedTab: null,
      isLoggedIn: false,
      userName: null,
      showDropdown: false,
      
      
    };
  },
  
  computed: {
  visibleRoutes() {
    // Jeśli użytkownik ma tylko rolę 'Admin', pokaż tylko 'Strona główna' i 'Rejestruj trenera'
    if (this.userRole === 'Admin') {
      return this.routes.filter(route => route.name === 'Strona główna' || route.name === 'Rejestruj trenera');
    }

    // Jeśli użytkownik ma role 'Trener,Admin', pokaż wszystkie ścieżki
    if (this.userRole === 'Trener,Admin') {
      return this.routes;
    }

    // Jeśli użytkownik jest trenerem, ale nie administratorem, ukryj 'Rejestruj trenera'
    if (this.userRole === 'Trener') {
      return this.routes.filter(route => route.name !== 'Rejestruj trenera');
    }

    // Dla innych ról (np. dziecko, rodzic) filtrowanie ścieżek jak wcześniej
    if (!this.userRole || this.userRole.includes('dziecko') || this.userRole.includes('rodzic')) {
      return this.routes.map(route => {
        if (route.name === 'Ćwiczenie') {
          return { ...route, children: route.children.filter(child => child.name === 'Lista ćwiczeń') };
        } else if (route.name === 'Zarejestruj zawodnika' || route.name === 'Stwórz plan' || route.name === 'Rejestruj trenera') {
          return null;
        }
        return route.name !== 'Trening' ? route : null;
      }).filter(route => route !== null);
    }

    return [];
  }
},

  created() {
    this.checkLoginStatus();
  },
  methods: 
    {

      onLoggedIn() {
        this.checkLoginStatus();
      },

        checkLoginStatus() {
      const token = localStorage.getItem('authToken');
      const userData = localStorage.getItem('userData') ? JSON.parse(localStorage.getItem('userData')) : null;
      if (token && userData) {
        this.isLoggedIn = true;
        this.userName = userData.imie; 
        this.userRole = userData.rola;
       
        
      }
    },

    fetchUserData() {
      axios.get('http://127.0.0.1:8000/api/user', { 
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('authToken')}`
        }
      })
      .then(response => {
        this.userName = response.data.imie; // Załóżmy, że imię użytkownika znajduje się w odpowiedzi
      })
      .catch(error => {
        console.error("Błąd przy pobieraniu danych użytkownika", error);
      });
    },
    toggleDropdown() {
      this.showDropdown = !this.showDropdown;
    },
    navigateTo(path) {
      this.$router.push(path);
    },
    navigateToLogin() {
      this.$router.push('/login');
    },
    navigateToProfile() {
      this.$router.push('/profile-update');
    },
    handleLoginSuccess(userName) {
      this.isLoggedIn = true;
      this.userName = userName;
      this.checkLoginStatus();
    },
    navigateToUpdateProfile() {
      this.$router.push('/profilecompletion');
    },

    logout() {
      axios.post('http://127.0.0.1:8000/api/logout', {}, {
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('authToken')}`
        }
      })
      .then(() => {
        localStorage.removeItem('authToken');
        localStorage.removeItem('userData');
        localStorage.removeItem('userRole');
        this.isLoggedIn = false;
        this.userName = null;
        this.userRole = null;
        this.$router.push('/');
        this.$toast.add({severity: 'info', summary: 'Wylogowano', detail: 'Wylogowałeś sie pomyślnie!', life: 3000});
        //this.$forceUpdate();

      })
      .catch(error => {
        console.error("Błąd przy wylogowaniu", error);
      });
    },
    highlightTab(index) {
      this.highlightedTab = index;
    },

  },
};
</script>

<style>



html, body {
  margin: 0;
  padding: 0;
}

body {
  background-attachment: fixed; /* Lub 'fixed', jeśli tło ma być nieruchome */
  background-position: top center; /* Zapewnia, że tło zaczyna się od góry strony */
  min-height: 100vh; /* Minimalna wysokość widoku, aby tło pokrywało całą stronę */
  background-repeat: no-repeat;
  background-attachment: fixed; /* This ensures that the background is fixed during scroll */
  background-position: top center; /* Centers the background image */
  background: url('http://127.0.0.1:8000/storage/boisko_czarne.jpg') no-repeat center center fixed;
  background-size: cover;
  
}


#app {
  display: flex;
  flex-direction: column;
  min-width: 20%;
  min-height: 100vh;
  text-align: left;
  
}


.top-bar, .navigation-bar {
  position: fixed;
  z-index: 1020; /* Any value higher than the content */
  width: 100%; /* Ensures it spans the entire width */
}


.content-wrapper {
  z-index: 6;
  position: relative; 
  flex-grow: 1;
  overflow: auto;
  
  /**max-height: calc(100vh - 60px);*/ 
  margin: auto;
  margin-top:80px
}


/* Nowy pasek na górze */
.top-bar {
  background-color: rgb(47, 47, 41);
  height: 5%;
  line-height: 30px;
  text-align: right;
  padding-right: 20px;
  color: white;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 101;
}

.login-section button, .user-info span {

  cursor: pointer;
  background: none;
  border: none;
  color: white;
}

.user-info {
  position: relative;
}

.dropdown-content {
  cursor: pointer;
  display: none;
  position: absolute;
  right: 20px;
  background-color: #f1f1f1;
  min-width: 160px;
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  z-index: 102;
  top: 30px;
}

.user-info:hover .dropdown-content {
  display: block;
}

.dropdown-content a {
  color: black;
  padding: 12px 16px;
  text-decoration: none;
  display: block;
}

.dropdown-content a:hover {
  background-color: #ddd;
}

/* Styl dla paska nawigacyjnego */
.navigation-bar {
  background-color: rgb(47, 47, 41);
  position: fixed;
  top: 1%;
  left: 0;
  right: 0;
  z-index: 100;
}

.navigation-bar ul ul {
  display: none;
  position: absolute;
 
  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
  padding: 12px 16px;
  z-index: 1000; /* Wysoka wartość z-index */
  width: 100%;
  left: 0;
 
}

.navigation-bar ul li:hover > ul {
  display: block;
  border-radius: 0;
}


nav ul {
  color: white;
  list-style: none;
  padding: 0;
  display: flex;
  justify-content: center;
  background-color: rgb(47, 47, 41);
  padding-top: 30px; /* Odstęp, aby uniknąć zakrywania przez górny pasek */
}

nav li {
  flex: 1;
  text-align: center;
  position: relative;
  background-color: rgb(47, 47, 41);
  transition: background-color 0.2s, color 0.2s;
  cursor: pointer;
  border-radius: 10px;
}

nav li:hover {
  background-color: rgb(87, 87, 92);
}





</style>
