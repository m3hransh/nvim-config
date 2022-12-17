local neodev_ok, neodev = pcall(require, "neodev")
if not neodev_ok then
  print "didn't load neodev"
  return
end
neodev.setup()
