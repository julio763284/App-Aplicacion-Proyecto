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