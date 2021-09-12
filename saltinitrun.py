#!/usr/bin/env python3

import asyncio
import os
import signal

cmds = {
    'SALT_API': 'salt-api',
    'SALT_MASTER': 'salt-master',
    'SALT_SYNDIC': 'salt-syndic'
}
    

async def main():
    futures = []
    
    for env, cmd in cmds.items():
        if env in os.environ:
            futures.append(
                await asyncio.create_subprocess_exec(cmd)
            )
    
    await asyncio.gather(*[future.communicate() for future in futures])


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    for signame in {"SIGINT", "SIGTERM"}:
        loop.add_signal_handler(getattr(signal, signame), loop.stop)

    try:
        loop.run_until_complete(main())
    finally:
        loop.close()
