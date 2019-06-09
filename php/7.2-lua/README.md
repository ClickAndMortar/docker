# PHP 7.2 wit LUA extension

PHP 7.2 based image with built-in LUA scripting extension.

## Usage

```bash
docker run --rm -ti clickandmortar/php:7.2-lua php -r '$lua = new Lua(); echo $lua->eval("print(\"Hello lua!\");").PHP_EOL;'
```

Will output:

```bash
Hello lua!
```

See [official PHP documentation](https://www.php.net/manual/fr/book.lua.php) for LUA usage.
