document.addEventListener("DOMContentLoaded", function () {

  VANTA.NET({
    el: "#index",
    mouseControls: true,
    touchControls: true,
    gyroControls: false,
    minHeight: 200,
    minWidth: 200,
    scale: 1,
    scaleMobile: 1,
    color: 0x08f5e9,
    backgroundColor: 0x0a1517
  });

  const logo = document.getElementById("logo");

  document.querySelectorAll("a").forEach(link => {
    link.addEventListener("click", function(e) {
      if (this.href && !this.href.includes("#")) {
        e.preventDefault();

        logo.classList.add("loading");

        setTimeout(() => {
          window.location.href = this.href;
        }, 400);
      }
    });
  });

});

document.addEventListener("DOMContentLoaded", () => {

    const imagenes = document.querySelectorAll(".imag_celular img");

    const observer = new IntersectionObserver((entries) => {

        entries.forEach(entry => {

            if (entry.isIntersecting) {
                entry.target.classList.add("show");
            } else {
                entry.target.classList.remove("show");
            }

        });

    }, {
        threshold: 0.2
    });

    imagenes.forEach(img => {
        observer.observe(img);
    });

});

        // 1. Manejador de Scroll Dinámico para resaltar el menú lateral activo
        const sections = document.querySelectorAll("section, header");
        const navLinks = document.querySelectorAll(".nav-link");

        window.addEventListener("scroll", () => {
            let current = "";
            sections.forEach(section => {
                const sectionTop = section.offsetTop;
                if (pageYOffset >= sectionTop - 150) {
                    current = section.getAttribute("id");
                }
            });

            navLinks.forEach(link => {
                link.classList.remove("active");
                if (link.getAttribute("href").includes(current)) {
                    link.classList.add("active");
                }
            });
        });

        // 2. Función interactiva para copiar código al portapapeles de forma nativa
        function copyCode(button) {
            const pre = button.nextElementSibling;
            const code = pre.textContent;
            navigator.clipboard.writeText(code).then(() => {
                button.textContent = "¡Copiado!";
                setTimeout(() => {
                    button.textContent = "Copiar";
                }, 2000);
            });
        }

        // 3. Motor del simulador de respuestas del Backend (Simulación de Arquitectura NestJS)
        function ejecutarSimulacion() {
            const endpoint = document.getElementById("sim-endpoint").value;
            const resultBox = document.getElementById("sim-result-box");
            
            resultBox.style.display = "block";
            resultBox.className = "sim-result"; // Limpiar estados previos
            
            if (endpoint === "auth-success") {
                resultBox.classList.add("success");
                resultBox.innerHTML = `
                    <strong>HTTP STATUS: 200 OK</strong> — Interceptor de Seguridad Aprobado<br><br>
                    <pre style="background: rgba(0,0,0,0.05); color: #22543d; border-left: none; padding: 10px; margin: 0;"><code>{
  "authenticated": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoibmV4dXMtYWRtaW4iLCJyb2wiOiJBZG1pbmlzdHJhZG9yIn0...",
  "expiresIn": "3600s",
  "roleAssigned": "Administrador"
}</code></pre>
                `;
            } else if (endpoint === "auth-fail") {
                resultBox.classList.add("error");
                resultBox.innerHTML = `
                    <strong>HTTP STATUS: 401 Unauthorized</strong> — Auth Guard Exception<br><br>
                    <pre style="background: rgba(0,0,0,0.05); color: #742a2a; border-left: none; padding: 10px; margin: 0;"><code>{
  "statusCode": 401,
  "message": "Las credenciales ingresadas no corresponden a ningún usuario activo en el directorio activo corporativo.",
  "error": "Unauthorized"
}</code></pre>
                `;
            } else if (endpoint === "rbac-block") {
                resultBox.classList.add("error");
                resultBox.innerHTML = `
                    <strong>HTTP STATUS: 403 Forbidden</strong> — RolesGuard Restriction<br><br>
                    <pre style="background: rgba(0,0,0,0.05); color: #742a2a; border-left: none; padding: 10px; margin: 0;"><code>{
  "statusCode": 403,
  "message": "Error de Privilegios: El rol 'Operador' no posee permisos de mutación destructiva para el recurso solicitado.",
  "error": "Forbidden"
}</code></pre>
                `;
            }
        }