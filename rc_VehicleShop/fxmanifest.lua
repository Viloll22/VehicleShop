fx_version 'adamant'

game 'gta5'


server_scripts {
    'config.lua',
	'server/main.lua',
    '@mysql-async/lib/MySQL.lua'
	
}

client_scripts {
    'config.lua',
	'client/main.lua'
}

ui_page "html/index.html"
files({
    'html/index.html',
    'html/index.js',
    'html/main.css',
    'html/Assets/car.png',
    'html/Assets/discount.png',
    'html/Assets/motorcycle.png',
    'html/Assets/truck.png',
    'html/Assets/Cars/testCar.png',
    'html/Assets/Cars/testCar2.png',
    'html/Assets/Cars/testCar3.png',
})