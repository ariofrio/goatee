#= require thirdparty/Three
#= require thirdparty/Detector
Three = THREE

# A placeholder for values that will be updated later. DRY.
placeholder = "If this is being used, we've got a problem."

# Cache the container.
container = $("#canvas")

# Scene, render, camera, control, lights
scene = new Three.Scene

renderer = if Detector.webgl then new Three.WebGLRenderer else new Three.CanvasRenderer
container.appendChild renderer.domElement

camera = new Three.PerspectiveCamera 45, placeholder, 0.01, 1000
camera.position.set 5, 5, 5
scene.add camera

controls = new Three.TrackballControls camera, container

keyLight = new Three.DirectionalLight 0xFFFFFF
keyLight.position.set 7, 10, 0
scene.add keyLight
fillLight = new Three.DirectionalLight 0x666666
fillLight.position.set -5, 7, 4
scene.add fillLight
bottomLight = new Three.DirectionalLight 0x666666
bottomLight.position.set 7, -5, 4
scene.add bottomLight
backLight = new Three.DirectionalLight 0xFFFFFF
backLight.position.set -5, -7, -4
scene.add backLight

# Update mesh when signaled.
mesh = null
loader = new Three.JSONLoader
App.updateMesh = ->
  scene.remove mesh if mesh?
  loader.createModel App.meshResult.three, (geometry) ->
    mesh = new Three.Mesh geometry,
      #new Three.MeshBasicMaterial color: 0xCC0000, wireframe: yes
      new Three.MeshPhongMaterial color: 0xCC0000
    mesh.doubleSided = yes
    scene.add mesh

# Responsive resizing
window.addEventListener 'resize', onresize = ->
  renderer.setSize container.clientWidth, container.clientHeight
  camera.aspect = container.clientWidth/container.clientHeight
  camera.updateProjectionMatrix()
onresize()

# Rendering loop.
render = ->
  requestAnimationFrame render
  controls.update()
  renderer.render scene, camera
render()
