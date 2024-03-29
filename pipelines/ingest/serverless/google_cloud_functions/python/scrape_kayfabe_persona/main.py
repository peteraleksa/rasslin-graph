import functions_framework
from typing import Dict, List
import asyncio
from aiohttp import ClientSession
from bs4 import BeautifulSoup
from utils import KafkaConnectGCFSinkRequest, format_response, get_html, parse_request, non_null_dict, scrape_all
import constants as _


class KayfabePersona:
    """

    """
    def __init__(self,
                 name: str,
                 wiki_tag: str = None,
                 cagematch_tag: str = None):
        self.name = name
        self.wikipediaTag = wiki_tag
        self.cagematchTag: cagematch_tag


async def scrape_persona(sem: asyncio.locks.Semaphore, session: ClientSession, msg: KafkaConnectGCFSinkRequest) -> Dict:
    """

    :param sem:
    :param session:
    :param msg:
    :return:
    """
    val: Dict = msg.value
    url: str = val.get(_.URL)
    html: BeautifulSoup = await get_html(sem=sem, session=session, url=url)
    if html:
        persona = KayfabePersona(name=html.find(class_="TextHeader").text)
        return format_response(msg=msg, response=non_null_dict(vars(persona)))
    else:
        return {}


@functions_framework.http
def get_persona_http(request):
    """

    :param request:
    :return:
    """
    requests = parse_request(request)
    return asyncio.run(scrape_all(requests, scrape_persona))
