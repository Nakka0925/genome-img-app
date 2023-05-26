from flask import Flask, jsonify, request
import json, os
import numpy as np
from typing import Dict, Tuple
from argparse import ArgumentParser, Namespace
import matplotlib
import matplotlib.pyplot as plt
from Bio import SeqIO, Seq
import gbk_utils
import tensorflow as tf
import cv2

app = Flask(__name__)

matplotlib.use("Agg")

def generate_image(acc,
                   sequense: Seq.Seq,
                   weight: dict,
                   pix_of_a_side: int = 192) -> matplotlib.figure.Figure:
    """配列をグラフ化する 

    Args:
        sequense (Seq.Seq): 塩基配列
        weight (dict): 重み
        pix_of_a_side (int, optional): 生成画像の一辺のピクセル数. Defaults to 192.

    Returns:
        matplotlib.figure.Figure: 生成された画像
    """
    x_coo, y_coo = calc_coordinates(sequense, weight)

    dpi = 100
    figsize = (pix_of_a_side / dpi, pix_of_a_side / dpi)
    fig = plt.figure(figsize=figsize, dpi=dpi)
    ax = fig.add_axes([0, 0, 1, 1])
    l = int(len(x_coo) / 255)
    mask = 0

    for i in range(1, 256):
        gray_scale = str(1 - (i / 255))
        ax.plot(x_coo[mask:mask+l], y_coo[mask:mask+l], color=gray_scale, lw=1)
        mask += l
    if len(x_coo) % 255 != 0:
        ax.plot(x_coo[mask:], y_coo[mask:], color='0.0', lw=1)
    
    # 先にそれぞれのcooをソートしてからmin,maxかけるのとどっちが早いんだろう
    format_graph_img(ax, min(x_coo), max(x_coo), min(y_coo), max(y_coo))

    dst = f"/home/nakanishi/rails/genome-img-app/app/assets/images/{acc}.png"
    plt.savefig(dst)
    plt.close()    # clear figure on each species
    return fig



def format_graph_img(ax: matplotlib.axes._axes.Axes, xmin: np.float64, xmax: np.float64,
                     ymin: np.float64, ymax: np.float64) -> None:
    """縦横比を揃えたりする

    Args:
        fig (matplotlib.figure.Figure): グラフ画像

    Returns:
        matplotlib.figure.Figure: [description]
    """
    ax.set_xlim(xmin, xmax)
    ax.set_ylim(ymin, ymax)
    ax.set_aspect("equal")
    ax.axis("off")


def calc_coordinates(seq: Seq.Seq, weight: dict) -> Tuple[list, list]:
    """入力された配列を数値化する

    Args:
        seq (Seq.Seq): 配列
        weight (dict): 重み

    Returns:
        Tuple[list, list]: x座標, y座標
    """
    VECTORS = {"A": (1, 1), "T": (-1, 1), "G": (-1, -1), "C": (1, -1)}
    x_coo, y_coo = [0], [0]
    for triplet in gbk_utils.window_serach(seq, overhang="before"):
        x_coo.append(x_coo[-1] + VECTORS[triplet[-1]][0] * weight.get(triplet, 1))
        y_coo.append(y_coo[-1] + VECTORS[triplet[-1]][1] * weight.get(triplet, 1))

    return x_coo, y_coo


@app.route("/", methods = ['GET'])
def predict():
    # model = tf.keras.models.load_model('saved_model/my_model')
    data = request.json
    acc = list(data.keys())
    seq = list(data.values())

    img_path = f"/home/nakanishi/rails/genome-img-app/app/assets/images/{acc[0]}.png"

    # 未知のデータの場合
    if not os.path.isfile(img_path):
        with open("weight.json") as f:
            weight = json.load(f)
            fig = generate_image(acc[0], seq[0], weight)


    ################################################################
    # train

    model = tf.keras.models.load_model('saved_model/my_model')
    img = cv2.imread(img_path)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    img = 1 - np.asarray(img, dtype=np.float16) / 255
    img = img.reshape(1,192,192,1)
    predictions = model.predict(img)

    return jsonify({"prediction":f"{predictions.argmax()}"})
# @app.route("/lang", methods = ['GET'])
# def returnAll():
#     return jsonify({'langages' : languages})

# @app.route("/lang/<string:name>", methods = ['GET'])
# def returnOne(name):
#     langs = [language for language in languages if language['name'] == name]
#     return jsonify({'langages' : langs[0]})


if __name__ == '__main__':
    app.debug = True
    app.run(host = '0.0.0.0')