<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Witaj w naszej drużynie</title>
</head>
<body>
    <h1>Witaj, {{ $imie }} {{ $nazwisko }}!</h1>
    <p>Zostałeś dodany jako trener w naszej akademii. Poniżej znajdziesz swoje dane do logowania:</p>
    <ul>
        <li>Login: <strong>{{ $login }}</strong></li>
        <li>Hasło: <strong>{{ $password }}</strong></li>
    </ul>
    <p>Zalecamy zmianę hasła po pierwszym logowaniu. Aby to zrobić, przejdź do ustawień swojego konta po zalogowaniu się do systemu.</p>
    <p>Jeśli masz jakiekolwiek pytania, prosimy o kontakt.</p>
    <p>Dziękujemy za dołączenie do naszego zespołu!</p>
</body>
</html>
