<template>
    <div class="content-container">
      <div class="content">
        <img src="http://127.0.0.1:8000/storage/logo_us.png" alt="Logo">
      </div>
      <footer class="footer" >
        <h3 id="tekst"> Projekt pracy inżynierskiej - Marcel Ścigaj, uniwersytetslaski.pl  &copy; 2024. Wszelkie prawa zastrzeżone.</h3>
      </footer>
    </div>
  </template>
  
  <style>
  html, body {
    
    margin: 0;
  }
  
  .content-container {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
  }
  
  .content {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
  }
  
  .footer {
    text-align: center;
    margin-top: auto;
  }
  #tekst{
    color:#2fff00;
  }
  </style>
  