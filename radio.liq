# 

out = output.icecast(
    host="localhost",
    port=8000,
    user="source",
    password="x",
    name="MUSICAL GARAGE",
    genre="Various",
    url="https://t.com/",
    encoding="UTF-8")

set("server.telnet.bind_addr","127.0.0.1")
set("server.telnet",true)

set("log.file.path","/home/svetlana/liquidsoap/main.log")
set("log.file.perms",388);
set("log.level", 3)

#radio = fallback([
#    playlist("/home/svetlana/radio.m3u"),
#    single("/home/svetlana/default.mp3")
#])

radio = playlist(reload = 360, mode = "random", "/home/svetlana/radio.m3u")

radio = crossfade(start_next=1., fade_out=1., fade_in=1., radio)

out(
    %mp3(
        bitrate = 128,
        id3v2 = true
    ),
    description = "Average 128Kbps",
    mount = "main",
    start = true,
    mksafe(radio)
)
