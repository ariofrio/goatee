#= require thirdparty/BlobBuilder
#= require thirdparty/FileSaver

$("#save").addEventListener 'click', ->
  bb = new BlobBuilder
  bb.append App.meshResult.msh
  saveAs bb.getBlob('text/plain;charset=utf-8'), 'untitled.msh'
