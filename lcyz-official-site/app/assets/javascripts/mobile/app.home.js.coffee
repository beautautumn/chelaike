class App.Home
  constructor: () ->

  render: ->
    $('.switch_item').click () ->
      itemId = $(this).data("item-id")
      $('.switch_item.active').removeClass('active')
      $(this).addClass('active')

      shown_item = $('.shown_item')
      shown_item.removeClass('shown_item').addClass('hidden_item').css('display', 'none')
      $("#"+itemId).addClass('shown_item').css('display', 'inline')


    $('#searchBar').on "submit", ->
      value = $("#searchInput").val()
      window.location = "/cars?query[name_cont]=" + value
      return false;

    if $(".ad-swiper .swiper-container").find(".swiper-slide").length > 0
      adSwiper = new Swiper('.ad-swiper .swiper-container',
        direction: 'horizontal',
        loop: true,
        effect: 'coverflow',
        spaceBetween: -15,
        autoplay: 2500,
        centeredSlides: true,
        autoplayDisableOnInteraction: false,
        slidesPerView: 1,
        slidesPerView: 'auto',
          coverflow: {
            rotate: 30,
            stretch: 10,
            depth: 30,
            modifier: 2,
            slideShadows : true
          }
        )
    if $(".car-swiper .swiper-container").find(".swiper-slide").length > 0
      carSwiper = new Swiper('.car-swiper .swiper-container',
        direction: 'horizontal',
        loop: true,
        slidesPerView: 1.3,
        spaceBetween: 17,
        centeredSlides: true,
        pagination: '.swiper-pagination',
        paginationType: 'fraction',
        autoplayDisableOnInteraction: false)


$(document).ready ->
  return unless $(".home.index").length > 0
  home = new App.Home
  home.render()

selectmenu = (n) ->
  eleMore = document.getElementById('brands_list')
  if eleMore.style.display == 'none'
    eleMore.style.display = 'block'
    $('#cell_' + n).removeClass 'icon-74'
    $('#cell_' + n).addClass 'icon-35 '
  else
    eleMore.style.display = 'none'
    $('#cell_' + n).removeClass 'icon-35'
    $('#cell_' + n).addClass 'icon-74'
  return

$('#refresh-all').click ->
  $('#car_type').val ''
  $('#car_price').val ''
  $('#car_ages').val ''
  $('#car_mileages').val ''
  $('#car_litre').val ''
  $('#car_effuent_standard').val ''
  $('#car_fuel').val ''
  $('#car_transmission').val ''
  $('#car_country').val ''
  $('#car_site_number').val ''
  $('#car_color').val ''
  $('.selected').each ->
    $(this).removeClass 'selected'
    return
  $('#search-car-result').text '为您找到0辆车'
  return
$('.multi_select').click ->
  $(this).toggleClass 'selected'
  return
$('.single_select').click ->
  if $(this).hasClass('selected')
    $(this).removeClass 'selected'
  else
    $(this).parents('table').find('.single_select').removeClass 'selected'
    $(this).addClass 'selected'
  return
$('.car_type_select').click ->
  new_value = ''
  $('.car_type_select').each ->
    if $(this).hasClass('selected')
      new_value = new_value + ',' + $(this).data('value')
    return
  $('#car_type').val new_value
  return
$('.effuent_standard_select').click ->
  new_value = ''
  $('.effuent_standard_select').each ->
    if $(this).hasClass('selected')
      new_value = new_value + ',' + $(this).data('value')
    return
  $('#car_effuent_standard').val new_value
  return
$('.fuel_select').click ->
  new_value = ''
  $('.fuel_select').each ->
    if $(this).hasClass('selected')
      new_value = new_value + ',' + $(this).data('value')
    return
  $('#car_fuel').val new_value
  return
$('.transmission_select').click ->
  new_value = ''
  $('.transmission_select').each ->
    if $(this).hasClass('selected')
      new_value = new_value + ',' + $(this).data('value')
    return
  $('#car_transmission').val new_value
  return
$('.country_select').click ->
  new_value = ''
  $('.country_select').each ->
    if $(this).hasClass('selected')
      new_value = new_value + ',' + $(this).data('value')
    return
  $('#car_country').val new_value
  return
$('.site_number_select').click ->
  new_value = ''
  $('.site_number_select').each ->
    if $(this).hasClass('selected')
      new_value = new_value + ',' + $(this).data('value')
    return
  $('#car_site_number').val new_value
  return
$('.color_select').click ->
  new_value = ''
  $('.color_select').each ->
    if $(this).hasClass('selected')
      new_value = new_value + ',' + $(this).data('value')
    return
  $('#car_color').val new_value
  return
$('.price_select').click ->
  new_value = $('.price_select.selected').data('value')
  $('#car_price').val new_value
  return
$('.age_select').click ->
  new_value = $('.age_select.selected').data('value')
  $('#car_ages').val new_value
  return
$('.mileages_select').click ->
  new_value = $('.mileages_select.selected').data('value')
  $('#car_mileages').val new_value
  return
$('.litre_select').click ->
  new_value = $('.litre_select.selected').data('value')
  $('#car_litre').val new_value
  return
$('.brand_item').click ->
  $('#brands_list').css 'display', 'none'
  $('#car_brand').val $(this).data('car-brand')
  return
$('.custome_input').click ->
  field_id = $(this).data('field-id')
  min = $(this).parents('tr').find('.min_range').val()
  max = $(this).parents('tr').find('.max_range').val()
  $('#' + field_id).val min + '-' + max
  return

$('.tc-brand-search a').click ->
  $(this).addClass('focus')

$('.btn_as_select').click ->
  car_brand = $('#car_brand').val()
  car_type_condition = $('#car_type').val()
  car_price_condition = $('#car_price').val()
  car_ages_condition = $('#car_ages').val()
  car_mileages_condition = $('#car_mileages').val()
  car_litre_condition = $('#car_litre').val()
  car_effuent_standard_condition = $('#car_effuent_standard').val()
  car_fuel_condition = $('#car_fuel').val()
  car_transmission_condition = $('#car_transmission').val()
  car_country_condition = $('#car_country').val()
  car_site_number_condition = $('#car_site_number').val()
  car_color_condition = $('#car_color').val()
  $.ajax
    url: '/home/condition_search'
    type: 'post'
    data:
      car_brand: car_brand
      car_type: car_type_condition
      show_price_cents: car_price_condition
      age: car_ages_condition
      mileage: car_mileages_condition
      displacement: car_litre_condition
      emission_standard: car_effuent_standard_condition
      fuel_type: car_fuel_condition
      transmission: car_transmission_condition
      country: car_country_condition
      site_number: car_site_number_condition
      exterior_color: car_color_condition
    success: (data) ->
      $('#search-car-result').text data
      return
  return
