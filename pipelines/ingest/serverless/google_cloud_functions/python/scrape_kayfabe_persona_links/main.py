import functions_framework
from typing import Dict, List, Callable, Awaitable
import asyncio
from aiohttp import ClientSession
from bs4 import BeautifulSoup
from utils import KafkaConnectGCFSinkRequest, format_response, get_html, parse_request, scrape_all
import constants as _


async def scrape_persona_links(sem: asyncio.locks.Semaphore, session: ClientSession, msg: KafkaConnectGCFSinkRequest) -> Dict:
    """

    :param sem:
    :param session:
    :param msg:
    :return:
    """
    val: Dict = msg.value
    url: str = val.get(_.URL)
    html: BeautifulSoup = await get_html(sem=sem, session=session, url=url)
    links = [a.get('href') for a in html.findAll(['a'])]
    persona_links = list(filter(lambda x: x and 'name=' in x, links))
    return format_response(msg=msg, response=persona_links)


@functions_framework.http
def get_persona_links_http(request):
    """

    kafka connect gcf connector request format:

        [
            {
                "key": ...,
                "value": ...,
                "topic": string,
                "partition": <number>,
                "offset": <number>,
                "timestamp": <number>
            },
            ...,
        ]

    :param request:
    :return:
    """
    requests: List[KafkaConnectGCFSinkRequest] = parse_request(request)
    return asyncio.run(scrape_all(requests, scrape_persona_links))
