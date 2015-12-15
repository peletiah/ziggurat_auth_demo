<%inherit file='base.mako' />

${ request.host }

% if failed_attempt:
    <p class="bg-danger">Invalid credentials, try again.</p>
% endif
<form method="post" action="${ request.route_url('ziggurat.routes.sign_in') }">
    <p>
        <label for="login">Login</label><br>
        <input type="text" name="login" value="">
    </p>
    <p>
        <label for="passwd">Password</label><br>
        <input type="password" value="" name="password">
    </p>
    <input type="hidden" name="came_from" value="${ came_from }">
    <input type="submit" value="Sign In" name="submit" id="submit">
</form>

<h3>Valid combinations in the default database:</h3>
<p>"admin",  password: "admin"</p>
<p>"editor",  password: "editor"</p>
<p>"luser",  password: "luser"</p>

