import json

data = [
    {
        "key": f"test-{i}",
        "value": {
            "url": f"https://www.cagematch.net/?id=2&nr={i}"
        },
        "topic": "test-topic",
        "partition": 1,
        "offset": i,
        "timestamp": 1
    }
    for i in range(1, 30)
]
print(json.dumps(data))
