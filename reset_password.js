    window.onload = function() {
        // Obtener los parámetros de la URL
        const params = new URLSearchParams(window.location.search);
        const email = params.get('email'); // Extrae el valor del parámetro 'email'

        if (!email) {
            // Si no se encuentra el parámetro 'email', muestra un mensaje de error
            document.getElementById('message').innerHTML = `
                <p>No se encontraron los parámetros necesarios en la URL. Por favor, verifica el enlace.</p>
            `;

             // Ocultar el botón si no hay parámetros
             document.getElementById('resetPasswordBtn').style.display = 'none';
        }
    };

    // Función para redirigir a la página de reset de contraseña con el deeplink
    function redirectToResetPassword() {
        const params = new URLSearchParams(window.location.search);
        const email = params.get('email');

        if (email) {
            const deeplink = "eval24://evalapp.com/reset_password/${email}";
            window.location.href = deeplink;
        }
    }