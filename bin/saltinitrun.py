#!/usr/bin/python3

import asyncio
import os
import signal


default = os.getenv('DEFAULT_RUN', 'SALT_MASTER')

cmds = {
    'SALT_API': '/opt/saltstack/salt/salt-api',
    'SALT_MASTER': '/opt/saltstack/salt/salt-master',
    'SALT_SYNDIC': '/opt/saltstack/salt/salt-syndic',
    'SALT_MINION': '/opt/saltstack/salt/salt-minion',
    'SALT_PROXY': '/opt/saltstack/salt/salt-proxy'
}


async def main():
    futures = []
    
    for env, cmd in cmds.items():
        if env in os.environ:
            futures.append(
                await asyncio.create_subprocess_exec(cmd)
            )
    
    if not futures and default in cmds:
        futures.append(
            await asyncio.create_subprocess_exec(cmds[default])
        )
    
    await asyncio.gather(*[future.communicate() for future in futures])


if __name__ == "__main__":
    loop = asyncio.new_event_loop()
    asyncio.set_event_loop(loop)

    for signame in {"SIGINT", "SIGTERM"}:
        loop.add_signal_handler(getattr(signal, signame), loop.stop)

    try:
        loop.run_until_complete(main())
    finally:
        loop.close()
