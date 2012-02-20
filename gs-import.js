$('.gs_r').each(function() {
  var cit_el = $(this);
  var links_el = cit_el.find('.gs_fl').last();
  var temp = links_el.html();
  links_el.html(temp + " - ")
          .append('<a href="#" class="rs_import">Import into reseachr</a>');
  links_el.find('.rs_import').click(function() {
    var pdf_url = cit_el.find('.gs_fl a:contains("[PDF]")').attr('href');
    var bibtex_url = links_el.find('a:contains("BibTeX")').attr('href');

    $.get(bibtex_url, function(data) {
      var payload = { citation : { bibtex : data, pdf_url : pdf_url }};
      $.post('http://localhost:3000/citations/', payload, function(data) {
        console.log(data);
      }, 'json');
    });
  });


});

