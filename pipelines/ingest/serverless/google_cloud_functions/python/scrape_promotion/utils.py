from typing import Any, Awaitable, Callable, Dict, List, Optional
from bs4 import BeautifulSoup
from aiohttp import ClientSession
import asyncio
import constants as _

headers = {'Accept-Encoding': 'identity'}


class KafkaConnectGCFSinkRequest:
    """

    """
    def __init__(self,
                 key: Any,
                 value: Dict,
                 topic: str,
                 partition: int,
                 offset: int,
                 timestamp: int):
        self.key = key
        self.value = value
        self.topic = topic
        self.partition = partition
        self.offset = offset
        self.timestamp = timestamp


def format_response(msg: KafkaConnectGCFSinkRequest, response: Any) -> Dict:
    """

    :param msg:
    :param response:
    :return:
    """
    return {
        _.PAYLOAD: {
            _.RESPONSE: response,
            _.TOPIC: msg.topic,
            _.PARTITION: msg.partition,
            _.OFFSET: msg.offset
        }
    }


async def get_html(sem: asyncio.locks.Semaphore, session: ClientSession, url: str) -> Optional[BeautifulSoup]:
    """

    :param sem:
    :param session:
    :param url:
    :return:
    """
    async with sem:
        async with session.get(url, headers=headers) as response:
            if not response.ok:
                print(f'Request failed with code {response.status}')
                return None
            page_text = await response.text()
        html = BeautifulSoup(page_text, 'html.parser')
        return html


def non_null_dict(original: Dict) -> Dict:
    """

    :param original:
    :return:
    """
    return {key: val for key, val in original.items() if val}


def parse_request(request) -> List[KafkaConnectGCFSinkRequest]:
    """

    :param request:
    :return:
    """
    request_json = request.get_json(silent=True)
    requests = [
        KafkaConnectGCFSinkRequest(
            key=msg.get(_.KEY),
            value=msg.get(_.VALUE),
            topic=msg.get(_.TOPIC),
            partition=msg.get(_.PARTITION),
            offset=msg.get(_.OFFSET),
            timestamp=msg.get(_.TIMESTAMP)
        ) for msg in request_json
    ]
    return requests


async def scrape_all(requests: List[KafkaConnectGCFSinkRequest],
                     scrape: Callable[[asyncio.Semaphore, ClientSession, KafkaConnectGCFSinkRequest], Awaitable[Dict]]) -> List[Dict]:
    """

    :param requests:
    :param scrape:
    :return:
    """
    async with ClientSession() as session:
        sem = asyncio.Semaphore(10)
        tasks = [asyncio.create_task(scrape(sem, session, sr)) for sr in requests]
        results = await asyncio.gather(*tasks)
        results = [res for res in results if res]
        return results
