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