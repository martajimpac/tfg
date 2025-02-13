
    window.onload = function() {
        // Obtener los parámetros de la URL
        const params = new URLSearchParams(window.location.search);
        const id = params.get('id'); // Extrae el valor del parámetro 'id'

        if (id) {

            // Construir el deeplink
            const deeplink = `eval24://evalapp.com/details?id=${id}&comesFromQR=true`;

            // Esperar 3 segundos antes de realizar la redirección
            setTimeout(() => {
                window.location.href = deeplink;
            }, 3000);

            // Mensaje de confirmación para redirección en curso
            setTimeout(() => {
                document.getElementById('message').innerHTML = `
                    <p>No hemos podido abrir la aplicación automáticamente.</p>
                    <button onclick="manualRedirect()">Abrir manualmente</button>
                    <p>Si el problema persiste, asegúrate de tener la aplicación instalada.</p>
                `;
            }, 3000); // Espera 3 segundos antes de mostrar el mensaje de error
        } else {
            // Mensaje si no se encuentra un ID en la URL
            document.getElementById('message').innerHTML = `
                <p>No se encontró un ID en la URL. Por favor, verifica el enlace.</p>
            `;
        }
    };

    // Función para redirigir manualmente
    function manualRedirect() {
        const params = new URLSearchParams(window.location.search);
        const id = params.get('id');
        if (id) {

             const deeplink = `eval24://evalapp.com/details?id=${id}&comesFromQR=true`;
             window.location.href = deeplink;
        }
    }