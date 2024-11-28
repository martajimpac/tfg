    window.onload = function() {
        // Obtener los parámetros de la URL
        const params = new URLSearchParams(window.location.search);
        const email = params.get('email'); // Extrae el valor del parámetro 'email'
        const token = params.get('token'); // Extrae el valor del parámetro 'token'

        if (!email || !token) {
            // Si no se encuentran los parámetros 'email' o 'token', muestra un mensaje de error
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
        const token = params.get('token');

        if (email && token) {
                    /*
                     encodeURIComponent() codifica los parámetros de la URL, garantizando que todos los caracteres especiales se
                     conviertan en su forma segura de escape y evitando que la URL sea interpretada incorrectamente o cause errores.
                     */
            const deeplink = "eval24://evalapp.com/reset_password/?email=${encodeURIComponent(email)}&token=${encodeURIComponent(token)}";
            window.location.href = deeplink;
        }
    }