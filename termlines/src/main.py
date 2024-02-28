import asyncio
import nats
import pyte
import json
from pprint import pprint
from nats.errors import ConnectionClosedError, TimeoutError, NoServersError


pyte_screen = pyte.Screen(420, 42)
pyte_stream = pyte.ByteStream(pyte_screen)
pytes = {}

def sync_function(arg):
    return arg.upper()

def sync_pyte(uuid, line):
    if (uuid not in pytes):
        pytes[uuid] = pyte.Screen(420, 42)

    pyte_screen = pytes[uuid]
    pyte_stream = pyte.ByteStream(pyte_screen)


    pyte_stream.feed(bytes(line, encoding='utf-8'))
    print(pyte_screen.display[0])
    pyte_screen.reset()


async def main():
    print("helloworld")
    nc = await nats.connect("nats://root:r00tpass@192.168.49.2:31692")

    async def message_handler(msg):
        subject = msg.subject
        reply = msg.reply
        data = json.loads(msg.data.decode())

        uuid = data["uuid"]
        #if (uuid not in pytes):
        #    pytes[uuid] = pyte.Screen(420, 42)

        #pyte_screen = pytes[uuid]
        #pyte_screen = pyte.Screen(420, 42)

        #pyte_stream = pyte.ByteStream(pyte_screen)
        #await asyncio.to_thread(sync_pyte, 'hello\r\n')
        #await asyncio.to_thread(sync_pyte, data["output_line"])
        sync_pyte(uuid, data["output_line"])

#        test = await pyte_stream.feed(bytes(data["output_line"], encoding='utf-8'))
#        print("Received a message on {data}".format(
#            data=data['output_line']))
#        await asyncio.sleep(1)
#        text = await ("".join([line.rstrip() + "\n" for line in pyte_screen.display][1:])).strip()
#        print(text)

    # Simple publisher and async subscriber via coroutine.
    sub = await nc.subscribe("rnd.io-lines", cb=message_handler)

    try:
        async for msg in sub.messages:
            print(f"Received a message on '{msg.subject} {msg.reply}': {msg.data.decode()}")
            #await sub.unsubscribe()
    except Exception as e:
        pass
    while True:
        # print("loop")
        await asyncio.sleep(10)


if __name__ == '__main__':
    asyncio.run(main())
