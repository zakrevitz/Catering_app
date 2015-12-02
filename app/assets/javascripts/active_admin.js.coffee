#= require active_admin/base
#= require select2

$(document).on('ready page:load', ->
  $('.select-two').select2({
    tags: true,
    placeholder: "Please select...",
    width: 'resolve'
    })
)