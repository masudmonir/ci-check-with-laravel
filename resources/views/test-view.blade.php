<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Laravel</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,600&display=swap" rel="stylesheet" />
</head>

<body class="antialiased">
    <h4>This is test view</h4>
    <p>You can create your own views in the resources/views directory.</p>
    <p>For example, you can create a file named <code>test-view.blade.php</code> and add your HTML content there.</p>
    <p>Then, you can return this view from a route or controller in your Laravel application.</p>
    <p>For example, you can add the following route in your <code>routes/web.php</code> file:</p>
    <pre><code>Route::get('/test', function () {
    return view('test-view');
});</code></pre>
    <p>Now, when you visit <code>/test</code> in your browser, you will see the content of your custom view.</p>
</body>

</html>
