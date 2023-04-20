<template>
  <div id="mainWindow" class="mainWindow">
    <div class="header">
      <img @click="showPanels()" id="returnIcon" class="returnIcon" src="@/assets/return.png">
      <div id="warningContainer" class="warningContainer">
        <p> Пожалуйста, заполните все параметры векторов </p>
        <p>(Все поля должны быть цифрами) </p>
        <p> ( B - начало ) (E - конец ) </p>
      </div>
    </div>

    <div id="leftSidePanel" class="leftSidePanel"> 
      <div class="header">
          <div class="titleAndImage">
            <img class="titleIcon" src="@/assets/pen.png">
            <span class="leftSideTitle"> Решение </span>
          </div>
      </div>
      <div class="solutionContainer">
        <p> {{ solutionText }} </p>
      </div> 
    </div>

    <div id="sceneHolder" class="sceneHolder"></div>

    <div id="rightSidePanel" class="rightSidePanel"> 
      <div class="header">
        <div class="titleAndImage">
          <img class="titleIcon" src="@/assets/coordinates.png">
          <span class="leftSideTitle"> Векторы </span>
        </div>
      </div>

      <div class="parametersSection">
        <div class="parametersHeader">
          <span> Параметры векторов </span>
        </div> 
        
        <div class="parametersVector">
          <div class="headerCoordinates">
            <span> X </span>
            <span> Y </span>
            <span> Z </span>
          </div>

          <div class="coordinateInputs">
            <form id="firstLineForm">
              <div>
                <input value="0" minlength="1" required="true" type="number" id="X1-B" placeholder="X1-B">
                <input value="0" minlength="1" required="true" type="number" id="Y1-B" placeholder="Y1-B">
                <input value="0" minlength="1" required="true" type="number" id="Z1-B" placeholder="Z1-B">
              </div>
              <div>
                <input value="6" minlength="1" required="true" type="number" id="X1-E" placeholder="X1-E">
                <input value="6" minlength="1" required="true" type="number" id="Y1-E" placeholder="Y1-E">
                <input value="6" minlength="1" required="true" type="number" id="Z1-E" placeholder="Z1-E">
              </div>
            </form>
          </div>

          <div style="margin-top: 40px;" class="headerCoordinates">
            <span> X </span>
            <span> Y </span>
            <span> Z </span>
          </div>

          <div class="coordinateInputs">
            <form id="secLineForm">
              <div>
                <input value="0" minlength="1" required="true" type="number" id="X2-B" placeholder="X2-B">
                <input value="0" minlength="1" required="true" type="number" id="Y2-B" placeholder="Y2-B">
                <input value="0" minlength="1" required="true" type="number" id="Z2-B" placeholder="Z2-B">
              </div>
              <div>
                <input value="3" minlength="1" required="true" type="number" id="X2-E" placeholder="X2-E">
                <input value="0" minlength="1" required="true" type="number" id="Y2-E" placeholder="Y2-E">
                <input value="3" minlength="1" required="true" type="number" id="Z2-E" placeholder="Z2-E">
              </div>
            </form>
          </div>
        </div>

      </div>

      <div class="taskButtons">
        <button @click="sumVectors()"> Сумма двух векторов </button> 
        <button @click="diffVectors()"> Разность двух векторов </button> 
        <button @click=""> Скалярное произведение двух векторов </button> 
        <button @click=""> Угол между двумя векторами </button>  
      </div>

      <div class="HideOrClearButtons">
        <button @click="hidePanels()" class="hidePanels"> Скрыть панели </button>
        <button @click="cleanScene()" class="clearButton"> Очистить </button>
      </div>

    </div>


  </div>
</template>

<script>
import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );
const renderer = new THREE.WebGLRenderer();
const controls = new OrbitControls( camera, renderer.domElement );

export default {
  name: 'Main',

  data() {
    return {
      solutionText: 'Здесь находится решение. Заполните все значения координат и выберите одну из задач',
      firstVectorLenght: [0,0,0],
      secVectorLenght: [0,0,0],
      linesCoords: {},
      xAxis: {
        begin: [-10000, 0, 0],
        end: [10000, 0, 0]
      },
      yAxis: {
        begin: [0, -10000, 0],
        end: [0, 10000, 0]
      },
      zAxis: {
        begin: [0, 0, -10000],
        end: [0, 0, 10000]
      },
    }
  },

  mounted() {
    this.setScene();
    this.createAxis();
    this.createAxisText();
    this.setCameraPosition();
  },

  methods: {
    // Basics 

    setScene() {
      scene.background = new THREE.Color( 0x252628 );
      // Set sizes and place it in sceneHolder
      renderer.setSize( window.innerWidth, window.innerHeight );
      const sceneHolder = document.querySelector('#sceneHolder');
      sceneHolder.appendChild( renderer.domElement );

      function animate() {
        requestAnimationFrame( animate );

        // Required if controls.enableDamping or controls.autoRotate are set to true
	      controls.update();

        renderer.render( scene, camera );
      }
      animate();
    },

    setCameraPosition() {
      camera.position.x = 10;
      camera.position.y = 8;
      camera.position.z = 10;

      camera.rotation.x = -0.5
      camera.rotation.y = 0.7
      camera.rotation.z = 0.45
    },

    createAxis() {
      // Creating XYZ axis
      this.createLine(0xff0000, this.xAxis, true)
      this.createLine(0x00ff00, this.yAxis, true)
      this.createLine(0x0000ff, this.zAxis, true)
    },

    createAxisText() {
      this.createText('#ff0000', '60px sans-serif', "X", [6, 1, 0],  [0, 0, 0]);
      this.createText('#00ff00', '60px sans-serif', "Y", [4, 4, 0],  [0, 0, 0]);
      this.createText('#0000ff', '60px sans-serif', "Z", [0, 1, 2],  [0, 1.7, 0]);
    },

    // Create objects (Text and lines)

    createText(color, font, text, coords, rotation) {
      const canvas = document.createElement('canvas')
      const context = canvas.getContext('2d')

      context.fillStyle = color
      context.font = font
      context.fillText(text, 10, 60, 10000)

      // Canvas contents are used for a texture

      const texture = new THREE.Texture(canvas)
      texture.needsUpdate = true

      var material = new THREE.MeshBasicMaterial({
        map: texture,
        side: THREE.DoubleSide,
      })
      material.transparent = true
      var mesh = new THREE.Mesh(new THREE.PlaneGeometry(5, 5), material)

      mesh.position.x = coords[0];
      mesh.position.y = coords[1];
      mesh.position.z = coords[2];

      mesh.rotation.x = rotation[0];
      mesh.rotation.y = rotation[1];
      mesh.rotation.z = rotation[2];

      scene.add(mesh);
    },

    createLine(color, coords, dashed) {
      if (dashed) { // For axis mostly
        var material = new THREE.LineDashedMaterial( {
          color: color,
          linewidth: 10,
          scale: 1,
          dashSize: 1,
          gapSize: 1,
        });
      }
      else {
        var material =  new THREE.LineBasicMaterial( { color: color } );
      }

      const points = [];
      points.push( new THREE.Vector3(coords.begin[0], coords.begin[1], coords.begin[2]) ); // First three numbers - line begin
      points.push( new THREE.Vector3(coords.end[0], coords.end[1], coords.end[2]) ); // Last three numbers - line end

      const geometry = new THREE.BufferGeometry().setFromPoints( points );
      const line = new THREE.Line( geometry, material );
      line.computeLineDistances();

      scene.add(line);
    },

    // Vectors functions

    sumVectors() {
      this.cleanScene();
      this.getUserCoords();

      if (this.linesCoords != undefined) {
        // First vector
        this.createLine(0x76a900, this.linesCoords.firstLine, false);

        // The second vector goes from the end of the first vector
        this.linesCoords.secLine.begin = this.linesCoords.firstLine.end;
        for (let i = 0; i < 3; i++) {
          this.linesCoords.secLine.end[i] += this.linesCoords.secLine.begin[i];
        }
        this.createLine(0x30d5c8, this.linesCoords.secLine, false);

        // Summary vector
        let sumVector = {
          begin: this.linesCoords.firstLine.begin,
          end: this.linesCoords.secLine.end
        }
        this.createLine(0xFFC0CB, sumVector, false);
      }
    },

    diffVectors() {
      this.cleanScene();
      this.getUserCoords();

      if (this.linesCoords != undefined) {
        
        // Bring vectors to one point, preserving their length
        for (let i = 0; i < 3; i++) {
          this.linesCoords.firstLine.end[i] += this.linesCoords.firstLine.begin[i]
          this.linesCoords.secLine.end[i] += this.linesCoords.secLine.begin[i];
        }
        this.linesCoords.firstLine.begin = [0, 0, 0];
        this.linesCoords.secLine.begin = [0, 0, 0];

        this.createLine(0x76a900, this.linesCoords.firstLine, false);
        this.createLine(0x30d5c8, this.linesCoords.secLine, false);

        // Diff vector
        let diffVector = {
          begin: this.linesCoords.firstLine.end,
          end: this.linesCoords.secLine.end
        }
        this.createLine(0xFFC0CB, diffVector, false);

        this.diffVectorsSolution();
      }
    },

    // Solution texts
    diffVectorsSolution() {
      this.getUserCoords();
      this.solutionText = "Разность двух векторов: \n\n";
      this.findVectorsLenghts();
      this.findDiffVectors();
    },

    findVectorsLenghts() {
      for (let i = 0; i < 3; i++) {
        this.firstVectorLenght[i] = this.linesCoords.firstLine.end[i] - this.linesCoords.firstLine.begin[i];
        this.secVectorLenght[i] = this.linesCoords.secLine.end[i] - this.linesCoords.secLine.begin[i];
      }
      this.solutionText = "Найдём вектора по координатам точек: \n\n";
      this.solutionText += "Первый вектор: \n";
      this.solutionText += `{${this.linesCoords.firstLine.end}} - {${this.linesCoords.firstLine.begin}} = {${this.firstVectorLenght}} \n\n`;
      this.solutionText += "Второй вектор: \n";
      this.solutionText += `{${this.linesCoords.secLine.end}} - {${this.linesCoords.secLine.begin}} = {${this.secVectorLenght}}  \n\n`;
    },

    findDiffVectors() {
      this.solutionText += "Найдём разность векторов: \n\n";
      this.solutionText += `{${this.firstVectorLenght}} - {${this.secVectorLenght}}`

      let diffVectors = [0,0,0];
      for (let i = 0; i < 3; i++) {
        diffVectors[i] = this.firstVectorLenght[i] - this.secVectorLenght[i];
      }

      this.solutionText += ` = {${diffVectors}}`
    },

    // Get information

    getUserCoords() {
      const firstLineForm = document.getElementById('firstLineForm');
      const secLineForm = document.getElementById('secLineForm');

      if (firstLineForm.checkValidity() && secLineForm.checkValidity()) {
        let linesCoords = {
          firstLine: {
            begin: [],
            end: []
          },
          secLine: {
            begin: [],
            end: []
          }
        }
        for (let i = 0; i < 6; i++) {
          if (i < 3) {
            linesCoords.firstLine.begin.push(parseInt(firstLineForm[i].value, 10));
            linesCoords.secLine.begin.push(parseInt(secLineForm[i].value, 10));
          }
          else {
            linesCoords.firstLine.end.push(parseInt(firstLineForm[i].value, 10));
            linesCoords.secLine.end.push(parseInt(secLineForm[i].value, 10));
          }
        }
        this.linesCoords = linesCoords;
      }
      else {
        this.showWarning();
        this.linesCoords = undefined;
      }
    },

    // Panels cleaning showing and hidding

    cleanScene() {
      scene.clear();
      this.createAxis();
      this.createAxisText();

      this.solutionText = 'Здесь находится решение. Заполните все значения координат и выберите одну из задач';
    },

    showWarning() {
      document.getElementById('warningContainer').style.top = "42px";

      setTimeout(() => document.getElementById('warningContainer').style.top = "-190px", 7000);
    },

    hidePanels() {
      document.getElementById('leftSidePanel').style.left = "-270px";
      document.getElementById('rightSidePanel').style.right = "-300px";

      document.getElementById('returnIcon').style.display = "block";
    },

    showPanels() {
      document.getElementById('leftSidePanel').style.left = "0px";
      document.getElementById('rightSidePanel').style.right = "0px";

      document.getElementById('returnIcon').style.display = "none";
    },
  }
}

</script>

<style>
  /* Fonts and colors */

  @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@300&display=swap');

  :root {
    --main-background: #252628;
    --panel-header-background: #424848;
    --panel-main-background: #373c3d;

    --inputs-background-hover: #616768;
    --inputs-borders-color: #5c5e68;

    --main-color: #009cd8;
    --parameters-color: #e1e3ee;

    --main-font: 'Roboto', sans-serif;
  }

  /* Main stuff */
  
  body {
    top: 0;
    left: 0;

    margin: 0;

    overflow-y: hidden;
    overflow-x: hidden;

    font-family: var(--main-font);
  }

  .mainWindow {
    height: 1080px;
    width: 1920px;

    background: var(--main-background);
  }

  .header {
    height: 40px;
    width: 100%;

    background: var(--panel-header-background);
  }

  .returnIcon {
    top: 5px;
    right: 10px;
    position: absolute;

    display: none;

    height: 32px;
    width: 32px;

    filter: invert(49%) sepia(72%) saturate(5010%) hue-rotate(171deg) brightness(100%) contrast(104%);

    cursor: pointer;
  }

  .returnIcon:hover {
    filter: invert(60%) sepia(66%) saturate(753%) hue-rotate(165deg) brightness(101%) contrast(95%);
  }

  .warningContainer {
    top: -190px;
    right: 300px;

    position: absolute;

    height: 190px;
    width: 300px;

    color: var(--parameters-color);
    background: var(--main-color);

    transition: 0.5s;
  }

  .warningContainer p {
    margin: auto;
    margin-top: 20px;

    width: 250px;

    text-align: center;
  }


  /* No buttons on input number on all browsers */
  input::-webkit-outer-spin-button,
  input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }

  input[type=number] {
    -moz-appearance: textfield;
  }

  /* Left side panel */

  .leftSidePanel {
    top: 42px;
    left: 0;

    position: absolute;

    height: 100%;
    width: 270px;

    color: var(--main-color);
    background: var(--panel-main-background);

    transition: 0.5s;
  }

  .titleAndImage {
    padding-top: 7px;
    padding-left: 10px;

    font-size: 18px;

    color: var(--main-color);
  }

  .titleIcon {
    transform: translateY(3px);

    margin-right: 5px;

    height: 20px;
    width: 20px;

    filter: invert(49%) sepia(72%) saturate(5010%) hue-rotate(171deg) brightness(100%) contrast(104%);
  }

  .solutionContainer {
    margin: auto;

    width: 250px;

    white-space: pre-wrap;
  }

  /* Main section */

  .sceneHolder {
    background: #009cd8;
  }


  /* Right side panel */

  .rightSidePanel {
    right: 0px;
    top: 42px;

    position: absolute;

    width: 300px;
    height: 650px;

    background: var(--panel-main-background);
    
    transition: 0.5s;
  }

  .parametersSection {
    height: 270px;

    color: var(--parameters-color);
  }

  .parametersHeader {
    margin: 20px;
    text-align: center;
  }

  .parametersVector {
    height: 150px;
  }

  .headerCoordinates {
    margin-top: 20px;

    text-align: center;
  }

  .headerCoordinates span {
    display: inline-block;

    width: 72px;
  }

  .coordinateInputs {
    margin-top: 10px;

    display: grid;

    justify-content: center;
  }

  .coordinateInputs input {
    height: 20px;
    width: 65px;

    border: solid var(--inputs-borders-color) 1px;

    text-align: center;

    color: var(--parameters-color);
    background: transparent;
  }

  .coordinateInputs input::placeholder {
    text-align: center;
  }

  .taskButtons {
    margin: auto;

    display: grid;
    width: fit-content;

    text-align: center;
  }

  .taskButtons button {
    all: unset;

    margin-bottom: 5px;

    padding: 5px;

    height: 32px;
    width: 200px;

    border: 1px solid var(--inputs-borders-color);

    color: var(--parameters-color);
    
    font-size: 14px;

    transition: 0.2s;
    cursor: pointer;
  }
  .taskButtons button:hover {
    background: var(--inputs-background-hover);
  }

  .HideOrClearButtons {
    margin: auto;
    margin-top: 20px;

    width: fit-content;

    text-align: center;

    display: grid;
  }

  .HideOrClearButtons button {
    margin-bottom: 5px;

    height: 35px;
    width: 210px;

    font-size: 14px;

    color: var(--parameters-color);

    transition: 0.2s;

    cursor: pointer;
  }

  .clearButton, .hidePanels {
    all: unset;

    border: 1px solid var(--inputs-borders-color);
  }

  .clearButton:hover, .hidePanels:hover {
    background: var(--inputs-background-hover);
  }

</style>
