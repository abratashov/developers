window.checkNewUser = (selector, sb_sel) ->
  sub_selector = sb_sel || '#' + selector.slice(5)
  user_pass = $("#{selector} #{sub_selector}_password").tipsy()
  user_email = $("#{selector}  #{sub_selector}_email").tipsy()
  user_phone = $("#{selector}  #{sub_selector}_phone").tipsy()
  user_first_name = $("#{selector}  #{sub_selector}_first_name").tipsy()
  user_last_name = $("#{selector} #{sub_selector}_last_name").tipsy()
  patternEmail = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,5}$/i
  patternPhone = /^\(\d{3}\)\d{3}\-\d{2}\-\d{2}$/
  patternPass = /[^а-я]+/i
  patternNameLastname = /[а-яa-z0-9_-]+/i


  if patternEmail.test(user_email.val()) and (if user_phone.val() then patternPhone.test(user_phone.val()) else true) and patternPass.test(user_pass.val()) and patternNameLastname.test(user_first_name.val()) and (if user_pass then patternNameLastname.test(user_last_name.val()) else true)
    return true
  else

    #check email
    hideEmail = ->
      user_email.tipsy "hide"

    #check phone
    hidePhone = ->
      user_phone.tipsy "hide"

    #check pass
    hidePass = ->
      user_pass.tipsy "hide" if user_pass

    #check first name
    hideFirstName = ->
      user_first_name.tipsy "hide"

    #check last name
    hideLastName = ->
      user_last_name.tipsy "hide"

    if user_email.length > 0
      if user_email.val() is ""
        user_email.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.empty_field
        user_email.tipsy "show"
      else unless patternEmail.test(user_email.val())
        user_email.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.email_incorrect
        user_email.tipsy "show"
    setTimeout hideEmail, 1500
    if user_phone.length > 0
      unless patternPhone.test(user_phone.val())
        user_phone.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.phone_incorrect
        user_phone.tipsy "show"
      else if user_phone.val() is ""
        user_phone.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.empty_field
        user_phone.tipsy "show"
    setTimeout hidePhone, 1500
    if user_pass.length > 0
      unless patternPass.test(user_pass.val())
        user_pass.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.pass_incorrect
        user_pass.tipsy "show"
      else if user_pass.val().length < 5
        user_pass.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.pass_too_short
        user_pass.tipsy "show"
      else if user_pass.val() is ""
        user_pass.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.empty_field
        user_pass.tipsy "show"
      setTimeout hidePass, 1500
    if user_first_name.length > 0
      unless patternNameLastname.test(user_first_name.val())
        user_first_name.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.enter_name
        user_first_name.tipsy "show"
      else if user_first_name.val().length < 2
        user_first_name.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.name_too_short
        user_first_name.tipsy "show"
      else if user_first_name.val() is ""
        user_first_name.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.empty_field
        user_first_name.tipsy "show"
    setTimeout hideFirstName, 1500
    if user_last_name.length > 0
      unless patternNameLastname.test(user_last_name.val())
        user_last_name.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.enter_surname
        user_last_name.tipsy "show"
      else if user_last_name.val().length < 2
        user_last_name.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.surname_too_short
        user_last_name.tipsy "show"
      else if user_last_name.val() is ""
        user_last_name.attr "original-title", I18n.translations["#{window.language}"].admin_js.validation_message.empty_field
        user_last_name.tipsy "show"
    setTimeout hideLastName, 1500
    return false
  false

FormValidateTwo = (selector, sb_sel, cb) ->
  $("#user_phone").mask "(999)999-99-99"
  $("#reservation_phone").mask "(999)999-99-99"
  $("#{selector}").off 'submit'
  $("#{selector}").on 'submit', (e) ->
    return e.preventDefault() unless window.checkNewUser(selector, sb_sel)
    cb(selector)

$(document).ready ->
  successCallback = (formSelector) ->
    $button = $("#{formSelector} input[type='submit']")
    $button.val('Подождите TopReserve бронирует столик для Вас')
    $button.css
      'background':'#fff'
      'color': '#08C'
      'z-index': '1000'
      'display': 'block'
      'width':'100%'
      'height':'100%'
      'top': '-10px'
      'left': '-100px'
      'position': 'fixed'
      'opacity': '0.95'
      'filter': 'alpha(opacity=95)'


  #    validateEmail();
  #    enter_phone();
  #    validPass();
  #    validNameLastname();
  window.language = $('#lang a:first').data('id')

  new FormValidateTwo("#new_user") if $("#new_user").length > 0
  new FormValidateTwo("#new_reservation", undefined, successCallback) if $("#new_reservation").length > 0
  new FormValidateTwo("form[id^='edit_user']", '#user') if $("form[id^='edit_user']").length > 0
  new FormValidateTwo("form[id^='edit_reservation']", '#reservation') if $("form[id^='edit_reservation']").length > 0

