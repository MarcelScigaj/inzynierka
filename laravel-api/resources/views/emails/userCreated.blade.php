<!DOCTYPE html>
<html>
<head>
    <title>Informacje o Kontach</title>
</head>
<body>
    <h2>Witam na mojej platformie  SciguClub!</h2>
    <h1>Cieszymy się że dołączyłeś do naszej akademii w celu dalszego rozwoju piłkarskiego</h1>
    <p>Dane do logowania dla konta dziecka:</p>
    <p>Login: {{ $childLogin }}</p>
    <p>Hasło: {{ $childPassword }}</p>
    @if ($parentAccount)
        <p>Dane do logowania dla konta rodzica:</p>
        <p>Login: {{ $parentLogin }}</p>
        <p>Hasło: {{ $parentPassword }}</p>
    @endif

    <p>Zalecamy zmianę hasła po pierwszym logowaniu. Aby to zrobić, przejdź do ustawień swojego konta po zalogowaniu się do systemu.</p>
    <p>Jeśli masz jakiekolwiek pytania, prosimy o kontakt.</p>
    <p>Dziękujemy za dołączenie do naszego zespołu!</p>
</body>
</html>