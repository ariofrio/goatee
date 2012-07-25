#= require thirdparty/reqwest

# The URL that will mesh our geometry. Try '/echo' or '/mesh/gmsh'.
url = '/mesh/gmsh'

textarea = $("textarea")
canvas = $("#canvas")
previousValue = null
retryInterval = 0.5
update = ->
  if previousValue != textarea.value
    canvas.classList.add 'loading'
    reqwest
      url: url
      method: 'post'
      type: 'json'
      data: input: textarea.value
      success: (res) ->
        retryInterval = 0.5

        App.updateMesh res.three
        canvas.classList.remove 'loading'
      error: () ->
        retryInterval *= 2
        previousValue = null
        console.log "error meshing, retrying in #{retryInterval} seconds"
        setTimeout update, retryInterval * 1000
  previousValue = textarea.value

updateDebounced = update.debounce 250
textarea.addEventListener 'keyup', updateDebounced
textarea.addEventListener 'change', updateDebounced
update()

