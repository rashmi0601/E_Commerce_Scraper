$(document).on('turbolinks:load', function () {
  $('#search-form').on('keyup', '#search-input', function () {
    const query = $(this).val();
  
    if (query.length > 2) {
      $.ajax({
        url: '/products',
        type: 'GET',
        dataType: 'script',
        data: { query: query },
        success: function (data) {
          const htmlString = $('#product-results').html(); 
          const parser = new DOMParser();
          const doc = parser.parseFromString(htmlString, 'text/html');
          $('#product-results').html(doc.body.innerHTML); 
        },
        error: function () {
          console.error('Error fetching search results');
        },
      });
    }
  });
});
