---
name: building-streamlit-chat-apps
description: Builds chat interfaces and LLM-powered apps with Streamlit. Use when creating chatbots, conversational AI interfaces, integrating OpenAI/Anthropic/other LLMs, or implementing streaming responses.
---

# Building Streamlit Chat Apps

Streamlit provides chat elements for building conversational interfaces. The key is properly managing message history in session state.

## Basic Chat Pattern

```python
import streamlit as st

st.title("Chat App")

# Initialize message history
if "messages" not in st.session_state:
    st.session_state.messages = []

# Display message history
for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

# Handle new input
if prompt := st.chat_input("Message"):
    # Add user message
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    # Generate and display response
    response = generate_response(prompt)
    st.session_state.messages.append({"role": "assistant", "content": response})
    with st.chat_message("assistant"):
        st.markdown(response)
```

Store messages in session state. Without this, history is lost on every rerun.

## Streaming Responses

Use `st.write_stream()` for typewriter-effect output:

```python
from openai import OpenAI

client = OpenAI(api_key=st.secrets["OPENAI_API_KEY"])

if prompt := st.chat_input("Message"):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    with st.chat_message("assistant"):
        stream = client.chat.completions.create(
            model="gpt-4",
            messages=st.session_state.messages,
            stream=True,
        )
        response = st.write_stream(stream)  # Returns full text when done

    st.session_state.messages.append({"role": "assistant", "content": response})
```

`st.write_stream()` works with:
- OpenAI streaming responses (directly)
- Anthropic streaming responses
- Any generator yielding strings

### Custom Generator

```python
import time

def response_generator(text):
    for word in text.split():
        yield word + " "
        time.sleep(0.05)

with st.chat_message("assistant"):
    response = st.write_stream(response_generator("Hello, how can I help?"))
```

## With Anthropic Claude

```python
import anthropic

client = anthropic.Anthropic(api_key=st.secrets["ANTHROPIC_API_KEY"])

if prompt := st.chat_input("Message"):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    with st.chat_message("assistant"):
        with client.messages.stream(
            model="claude-sonnet-4-20250514",
            max_tokens=1024,
            messages=st.session_state.messages,
        ) as stream:
            response = st.write_stream(stream.text_stream)

    st.session_state.messages.append({"role": "assistant", "content": response})
```

## Chat Message Options

```python
# Custom avatars
with st.chat_message("user", avatar=":material/person:"):
    st.write("User message")

with st.chat_message("assistant", avatar=":material/smart_toy:"):
    st.write("Assistant message")

# Rich content in messages
with st.chat_message("assistant"):
    st.markdown("Here's a chart:")
    st.line_chart(data)
    st.code("print('hello')")
```

## User Feedback

```python
with st.chat_message("assistant"):
    st.markdown(response)
    feedback = st.feedback("thumbs")
    if feedback is not None:
        st.session_state.feedback = {
            "message": response,
            "rating": feedback  # 0 = thumbs down, 1 = thumbs up
        }
```

## Clear Chat

```python
if st.sidebar.button("Clear chat"):
    st.session_state.messages = []
    st.rerun()
```

## Complete Example

```python
import streamlit as st
from openai import OpenAI

st.title("💬 Chat")

client = OpenAI(api_key=st.secrets["OPENAI_API_KEY"])

if "messages" not in st.session_state:
    st.session_state.messages = []

for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

if prompt := st.chat_input("Message"):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    with st.chat_message("assistant"):
        stream = client.chat.completions.create(
            model="gpt-4",
            messages=st.session_state.messages,
            stream=True,
        )
        response = st.write_stream(stream)
    st.session_state.messages.append({"role": "assistant", "content": response})
```

## Reference

- [Chat elements docs](https://docs.streamlit.io/develop/api-reference/chat)
- [Build conversational apps tutorial](https://docs.streamlit.io/develop/tutorials/chat-and-llm-apps/build-conversational-apps)
