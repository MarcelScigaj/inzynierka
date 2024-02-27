<template>
  <vue-advanced-chat
    :current-user-id="currentUserId"
    :rooms="JSON.stringify(rooms)"
    :messages="JSON.stringify(messages)"
    :room-id="roomId"
    :theme="theme"
    :rooms-loaded="true"
    :show-add-room="true"
    :showAudio="false"
    :showFiles="false"
    @add-room="handleAddRoom"
    :messages-loaded="messagesLoaded"
    @fetch-messages="handleFetchMessages"
    @send-message="handleSendMessage"
  
  />

  <Dialog :visible="displayDialog" :modal="true" :style="{width: '50vw'}" >
    <template #header>
        <span id="dialog-header">Wybierz osobę</span>
    </template>
    <template #closeicon>
      <button @click="hideDialog" class="custom-close-button">X</button>
    </template>
    <div class="dialog-content">
          <Dropdown :options="users" optionLabel="name" v-model="selectedUser" editable placeholder="Podaj dane" />
          <Button label="Utwórz rozmowę" @click="selectUserAndCreateRoom" class="create-conversation-button"></Button>
      </div>
  </Dialog>

</template>
  

  <script>
  import axios from 'axios';
  import moment from 'moment';
  import 'moment-timezone';
  import Dialog from 'primevue/dialog';
  import Button from 'primevue/button';
  import Dropdown from 'primevue/dropdown';
  

  // :rooms-loaded="roomsLoaded" ???

  import { register } from 'vue-advanced-chat';
  register();

  // :menu-actions="menuActions" @menu-action-handler="menuActionHandler"

  export default {
    components:{
      Dialog,
      Button,
      Dropdown,
    },
    data() {
      return {
        currentUserId: "", //'id_zalogowanego_uzytkownika',
        rooms: [], // Tutaj pobierz listę konwersacji z API
        messages: [], // Tutaj pobierz wiadomości dla aktywnej konwersacji     
        messagesLoaded:false,
        roomId:null,
        theme: 'dark',
        displayDialog: false,
        selectedUser: null,
        users: [] ,
       
       
      }
    },
    mounted() {
  const userDataString = localStorage.getItem('userData');
  if (userDataString) {
    const userData = JSON.parse(userDataString);
    this.currentUserId = userData.id.toString(); // Zapewnienie, że mamy string
  }
  this.fetchConversations();
},
  
    methods: {

      menuActionHandler({ action, roomId }) {
			switch (action.name) {
				case 'inviteUser':
					return this.inviteUser(roomId)
				case 'removeUser':
					return this.removeUser(roomId)
				case 'deleteRoom':
					return this.deleteRoom(roomId)
			}
		},



  handleSendMessage(event) {
    
    const { roomId, content } = event.detail[0];
    console.log('Wysyłanie wiadomości:', { roomId, content, userId: this.currentUserId });

    console.log({
  konwersacja_id: roomId,
  tresc: content,
  uzytkownik_id: this.currentUserId,
  dataWyslania: moment().format('YYYY-MM-DD HH:mm:ss')
});


    axios.post(`http://127.0.0.1:8000/api/wiadomosci/${this.roomId}`, {
      konwersacja_id: roomId,
      tresc: content,
      uzytkownik_id: this.currentUserId,
      dataWyslania: moment().format('YYYY-MM-DD HH:mm:ss')
    }, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`
      }
    }).then((response) => {
  // Dodajemy nową wiadomość do stanu, zakładając że response zawiera nową wiadomość
  const newMessage = response.data; // Załóżmy, że serwer zwraca nową wiadomość w odpowiedzi
  const newMessageData = response.data;
  this.messages.push({
    _id: newMessage.id.toString(),
    content: newMessage.tresc,
    senderId: newMessage.uzytkownik_id.toString(),
    date: moment(newMessage.dataWyslania).format('YYYY-MM-DD'),
    timestamp: moment(newMessage.dataWyslania).format('HH:mm'),
  });

  this.updateRoomList(roomId, newMessage);

  this.messagesLoaded = true; // Opcjonalnie, jeśli używasz flagi do śledzenia stanu ładowania
})
.catch(error => {
  console.error('Error sending message:', error);
});
  },


  updateRoomList(roomId, newMessage) {
  const roomIndex = this.rooms.findIndex(room => room.roomId === roomId);
  if (roomIndex !== -1) {
    // Aktualizacja ostatniej wiadomości i sortowania
    this.rooms[roomIndex].lastMessage = {
      content: newMessage.tresc,
      timestamp: moment(newMessage.dataWyslania).format('HH:mm'),
    };
    this.rooms[roomIndex].sortOrder = new Date(newMessage.dataWyslania).getTime();

    // Przesuwanie pokoju na górę listy
    const updatedRoom = this.rooms.splice(roomIndex, 1)[0];
    this.rooms.unshift(updatedRoom);
  } else {
    // W przypadku, gdy nie ma jeszcze pokoju (dla nowych konwersacji)
    this.fetchConversations();
  }
},


  handleFetchMessages(event) {
    const roomId = event.detail[0].room.roomId;

  this.messagesLoaded = false;
  
  axios.get(`http://127.0.0.1:8000/api/wiadomosci/${roomId}`, {
    headers: {
      'Authorization': `Bearer ${localStorage.getItem('authToken')}`
    }
  })
  .then((response) => {
    this.messages = response.data.map((msg) => ({
      _id: msg.id.toString(),
      content: msg.tresc,
      senderId: msg.uzytkownik_id.toString(),
      date: moment(msg.dataWyslania).format('YYYY-MM-DD'),
      timestamp: moment(msg.dataWyslania).format('HH:mm'),
      
    }));
    this.messagesLoaded = true;
  })
  .catch(error => {
    console.error('Błąd pobierania wiadomości:', error);
    this.messagesLoaded = true;
  });
},

async fetchConversations() {
  try {
    const response = await axios.get('http://127.0.0.1:8000/api/konwersacje', {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`,
      },
    });



    this.rooms = response.data.map(room => {
      const defaultAvatar = 'https://img.freepik.com/premium-wektory/pilka-nozna-wektor-czarny-bialy_627786-242.jpg';
      
       // Znajdujemy awatar osoby, z którą zalogowany użytkownik prowadzi rozmowę
       let avatar = defaultAvatar;
      const otherParticipant = room.uczestnicy.find(u => u.id.toString() !== this.currentUserId);
      if (otherParticipant && otherParticipant.avatarUrl) {
        avatar = otherParticipant.avatarUrl;
      }



      return {
        roomId: room.id.toString(),
        roomName: room.nazwa,
        avatar: avatar,
        users: room.uczestnicy.map(u => ({
          _id: u.id.toString(),
          username: `${u.imie} ${u.nazwisko}`,
          avatar: u.avatar || defaultAvatar,
        })),
        lastMessage: room.ostatniaWiadomosc ? {
          content: room.ostatniaWiadomosc,
          timestamp: this.formatDate(room.dataOstatniejWiadomosci),
        } : null,
        // Użyj daty ostatniej wiadomości lub daty utworzenia konwersacji, jeśli nie ma jeszcze wiadomości
        sortOrder: room.ostatniaWiadomosc ? new Date(room.dataOstatniejWiadomosci).getTime() : new Date().getTime(),
      };
    }).sort((a, b) => b.sortOrder - a.sortOrder); // Sortowanie malejąco

    
    if (this.rooms.length > 0) {
      this.roomId = this.rooms[0].roomId;
    }
  } catch (error) {
    console.error('Błąd pobierania konwersacji:', error);
  }
},



    formatDate(isoString) {
  // Ustawienie strefy czasowej dla konkretnego przypadku - dla Polski 'Europe/Warsaw'
  const date = moment.tz(isoString, "Europe/Warsaw");

  const today = moment().tz("Europe/Warsaw").startOf('day');
  const yesterday = moment().tz("Europe/Warsaw").subtract(1, 'days').startOf('day');

  if (date.isSame(today, 'd')) {
    return `Today, ${date.format('HH:mm')}`;
  } else if (date.isSame(yesterday, 'd')) {
    return `Yesterday, ${date.format('HH:mm')}`;
  } else {
    return date.format('DD/MM/YYYY');
  }
},

    handleAddRoom() {
        this.displayDialog = true;
        this.fetchUsersForConversation();
        // Załaduj listę użytkowników, jeśli jest to potrzebne
    },
    hideDialog() {
        this.displayDialog = false;
    },
    selectUserAndCreateRoom() {
        // Logika tworzenia nowego pokoju z wybranym użytkownikiem
        this.createConversation(this.selectedUser);
        this.hideDialog();
    },

    async fetchUsersForConversation() {
    try {
        const response = await axios.get(`http://127.0.0.1:8000/api/users-for-conversation/${this.currentUserId}`, {
            headers: { 'Authorization': `Bearer ${localStorage.getItem('authToken')}` },
        });
        this.users = response.data;
    } catch (error) {
        console.error('Błąd podczas pobierania użytkowników:', error);
    }
},

async createConversation(selectedUser) {
  if (!selectedUser) return;
  
  console.log(selectedUser);


  try {
    const response = await axios.post(`http://127.0.0.1:8000/api/konwersacje`, {
      // Przykład payloadu, dostosuj zgodnie z wymaganiami API
      typ: 'prywatna', // lub 'grupowa', w zależności od logiki biznesowej
      uzytkownik_id: selectedUser.id, // Zakładając, że `selectedUser` ma pole `id`
    }, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('authToken')}`,
      },
    });
    
   
    this.fetchConversations(); 
    
    console.log('Konwersacja została pomyślnie utworzona:', response.data);
  } catch (error) {
    if (error.response && error.response.status === 409) {
      this.$toast.add({
        severity: 'error',
        summary: 'Błąd',
        detail: error.response.data.message,
        life: 3000,
      });
    } else {
      console.error('Błąd podczas tworzenia konwersacji:', error);
    }
  }
}


    },
  };


  </script>
  
  <style >
  #dialog-header {
    color: #ffffff;
    font-family: 'Arial', sans-serif;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
  }

  .dialog-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 10px; 
  }

  .create-conversation-button {
    background-color: rgb(47, 47, 41);
    border: none;
    color: white;
    padding: 10px 20px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    cursor: pointer;
  }

  .custom-close-button {
    background-color: #000;
    color: #fff;
    border: none;
    cursor: pointer;
    font-size: 16px;
  }
  
  .p-dialog .p-dialog-header {
    background-color: rgba(0, 0, 0, 0.9) !important;
    color: #fff !important;
    border-radius: 10px; /* Zaokrąglenie krawędzi */
    border: 1px solid #fff; /* Biała ramka */
   
}

/* Zmiana tła ciała dialogu */
.p-dialog-content {
  padding-top: 10px;
    background-color: rgba(0, 0, 0, 0.8) !important;
    border-radius: 10px; /* Zaokrąglenie krawędzi */
    border: 1px solid #fff; /* Biała ramka */
}

</style>