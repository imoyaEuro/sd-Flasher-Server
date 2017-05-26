# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Package.delete_all
Game.delete_all
Provider.delete_all
SdPackage.delete_all
Sale.delete_all
User.delete_all

arcade_p = Package.create({:name => "arcade games", :description => "juegos ochenteros",
                           :price => 1, :logo => "http://hotwheelsskatecenter.com/wp-content/uploads/2013/12/arcade.jpg"})
cs_p = Package.create({:name => "CS Pack", :description => "Counter-Strike pack", :price => 5})
bf_p = Package.create({:name => "Battlefield pack", :description => "Battlefield pack", :price => 2})

cs = Game.create([
{:name => "Counter Strike", :description => "Counter-Strike is a first-person shooter game", :gamekey => "secretkey32423", :version => 1},
{:name => "Counter Strike 1.5", :description => "Counter-Strike 1.5 is a first-person shooter game", :gamekey => "secretkey_asdfasd", :version => 1},
{:name => "Counter Strike 1.6", :description => "Counter-Strike   1.6 is a first-person shooter game", :gamekey => "secretkey32423", :version => 1},
{:name => "Counter Strike Go", :description => "Counter-Strike Go is a first-person shooter game", :gamekey => "SECRETSDFSDF", :version => 1},
])
bf = Game.create([{:name => "Battlefield 1942", :description => "Battlefield 1942 is the first game in the Battlefield series. ", :gamekey => "2343243", :version => 1},
{:name => "Battlefield Vietnam", :description => "Battlefield Vietnam is a first-person shooter video game, the second in the Battlefield franchise after Battlefield 1942", :gamekey => "2SFAs3sfd", :version => 1},
])
arcade = Game.create([
{:name => "Pacman", :description => "Pacman description", :gamekey => "111111", :version => 1},
{:name => "Asteroids", :description => "Asteroids description", :gamekey => "33333333", :version => 1},
{:name => "Tetris", :description => "Soviet tile-matching puzzle video game originally designed and programmed by Alexey Pajitnov.",
 :gamekey => "sadf3w20s98dj", :version => 1, :version_description => "v1.0", :company => "Nintendo",
 :logo => "https://upload.wikimedia.org/wikipedia/en/8/8d/NES_Tetris_Box_Front.jpg",
 :image1 => "http://tetrisaxis.nintendo.com/_ui/img/bg/bg-tetris-10.png",
 :image3 => "http://www.geeksofdoom.com/GoD/img/2014/09/tetris-video-game.jpg"}
  ])

arcade_p.games << arcade
cs_p.games << cs
bf_p.games << bf

p1=Provider.new(:name => "Juan Perez", :email => "asdf1@asdf.com", :credit => 200000)
p1.save
p2=Provider.new(:name => "John Doe", :email => "asdf2@asdf.com", :credit => 10)
p2.save
p3=Provider.new(:name => "Satoshi Nakamoto", :email => "asdf3@asdf.com", :credit => 0)
p3.save
p4=Provider.new(:name => "Pepe", :email => "asdf4@asdf.com", :credit => 0)
p4.save

sd1=SdPackage.create(:key => "1234", :tablet=>"123456")
p1.sd_packages << sd1
sd2=SdPackage.create(:key => "1235", :tablet=> nil)
p2.sd_packages << sd2
sd3=SdPackage.create(:key => "123455", :tablet=>"1234567")
p1.sd_packages << sd3

Sale.create(:provider_id => p1.id, :package_id => arcade_p.id, :sd_package_id => sd3.id, :price => 3, :ip => "127.0.0.1")
Sale.create(:provider_id => p2.id, :package_id => cs_p.id, :sd_package_id => sd1.id, :price => 3, :ip => "127.0.0.1")
Sale.create(:provider_id => p3.id, :package_id => bf_p.id, :sd_package_id => sd2.id, :price => 3, :ip => "127.0.0.1")


user1 = FactoryGirl.create(:user,:email => "guest@example.com", :roles => [], :name => "Guest user",
                          :password => "12345678", :password_confirmation => "12345678")
user2 = FactoryGirl.create(:user,:email => "games_manager@example.com", :roles => [:games_manager, :packages_manager], :name => "Games and Packages manager",
                          :password => "12345678", :password_confirmation => "12345678")
user3 = FactoryGirl.create(:user,:email => "sdpackages_manager@example.com", :roles => [:sdpackages_manager, :providers_manager, :sales_manager], :name => "SdPackages and Providers manager",
                          :password => "12345678", :password_confirmation => "12345678")
user4 = FactoryGirl.create(:user,:email => "admin@example.com", :roles => [:admin], :name => "Admin",
                          :password => "12345678", :password_confirmation => "12345678")

