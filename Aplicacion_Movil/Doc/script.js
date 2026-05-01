const botonDoc = document.getElementById("btnDoc");

botonDoc.addEventListener("click", function(e){

e.preventDefault();

document.getElementById("documentacion")
.scrollIntoView({
behavior: "smooth"
});

});

const botonDiag = document.getElementById("btnDiag");

botonDiag.addEventListener("click", function(e){

e.preventDefault();

document.getElementById("diagramas")
.scrollIntoView({
behavior: "smooth"
});

});

const botonesHome = document.querySelectorAll(".btnHome");

botonesHome.forEach(function(boton){

boton.addEventListener("click", function(e){

e.preventDefault();

document.getElementById("home").scrollIntoView({
behavior: "smooth"
});

});

});

const logo = document.getElementById("logo");

document.querySelectorAll("a").forEach(link => {
  link.addEventListener("click", function(e) {
    if (this.href && !this.href.includes("#")) {
      e.preventDefault();

      // Activar animación tipo Google
      logo.classList.add("loading");

      setTimeout(() => {
        window.location.href = this.href;
      }, 400);
    }
  });
});