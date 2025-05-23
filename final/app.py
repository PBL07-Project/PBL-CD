import streamlit as st
import subprocess
import os

st.set_page_config(page_title="C Parser Web UI", layout="wide")

if "initialized" not in st.session_state:
    os.makedirs("static", exist_ok=True)
    subprocess.run(["flex", "-o", "static/lex.c", "lexer.l"], check=True)
    subprocess.run(["bison", "-d", "-o", "static/parser.c", "parser.y"], check=True)
    subprocess.run([
        "gcc", "-Wall", "-o", "static/processor",
        "static/lex.c", "static/parser.c"
    ], check=True)
    st.session_state.initialized = True

st.title("Compiler Craft: Source Code AST Generator")

input_method = st.radio("Select input method", ["Paste code", "Upload file"])

if input_method == "Paste code":
    code = st.text_area("Paste your C code here", height=300)
else:
    uploaded = st.file_uploader("Upload a C source file", type=["c"])
    code = ""
    if uploaded is not None:
        code = uploaded.read().decode("utf-8")
        st.text_area("File contents", code, height=300)

if st.button("Run") and code:
    with open("static/input.c", "w") as f:
        f.write(code)
    with open("static/input.c", "r") as infile:
        proc = subprocess.run(
            ["./processor"], cwd="static",
            stdin=infile,
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
        )
    with open("static/output.txt", "w") as f:
        f.write(proc.stdout)
        if proc.stderr:
            f.write("\nErrors:\n")
            f.write(proc.stderr)
    st.subheader("Output (output.txt)")
    st.code(open("static/output.txt").read(), language="text")
    png = "static/parse_tree.png"
    if os.path.exists(png):
        st.subheader("Parse Tree")
        st.image(png, use_container_width=True)
    else:
        st.error("parse_tree.png not found.")
