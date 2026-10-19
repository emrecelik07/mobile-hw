"""Generate original illustrative event images as PNG files (pure Python, no deps).

Usage: python make_images.py <output_dir>
"""
import math
import os
import struct
import sys
import zlib

W, H = 800, 450


def hexc(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i + 2], 16) / 255.0 for i in (0, 2, 4))


class Canvas:
    def __init__(self, top, bottom, diag=False):
        t, b = hexc(top), hexc(bottom)
        self.px = []
        for y in range(H):
            row = []
            for x in range(W):
                k = (x / W * 0.4 + y / H * 0.6) if diag else y / (H - 1)
                row.append([t[i] + (b[i] - t[i]) * k for i in range(3)])
            self.px.append(row)

    def _blend(self, x, y, col, a):
        p = self.px[y][x]
        for i in range(3):
            p[i] = p[i] * (1 - a) + col[i] * a

    def shape(self, sdf, bbox, color, alpha=1.0):
        col = hexc(color)
        x0, y0, x1, y1 = bbox
        x0, y0 = max(0, int(x0) - 2), max(0, int(y0) - 2)
        x1, y1 = min(W - 1, int(x1) + 2), min(H - 1, int(y1) + 2)
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                d = sdf(x + 0.5, y + 0.5)
                cov = 0.5 - d
                if cov <= 0:
                    continue
                if cov > 1:
                    cov = 1
                self._blend(x, y, col, cov * alpha)

    def circle(self, cx, cy, r, color, alpha=1.0):
        self.shape(lambda x, y: math.hypot(x - cx, y - cy) - r,
                   (cx - r, cy - r, cx + r, cy + r), color, alpha)

    def ring(self, cx, cy, r, w, color, alpha=1.0):
        self.shape(lambda x, y: abs(math.hypot(x - cx, y - cy) - r) - w / 2,
                   (cx - r - w, cy - r - w, cx + r + w, cy + r + w), color, alpha)

    def rect(self, x0, y0, x1, y1, color, radius=0.0, alpha=1.0):
        cx, cy = (x0 + x1) / 2, (y0 + y1) / 2
        hw, hh = (x1 - x0) / 2 - radius, (y1 - y0) / 2 - radius

        def sdf(x, y):
            qx, qy = abs(x - cx) - hw, abs(y - cy) - hh
            out = math.hypot(max(qx, 0), max(qy, 0))
            return out + min(max(qx, qy), 0) - radius

        self.shape(sdf, (x0, y0, x1, y1), color, alpha)

    def line(self, ax, ay, bx, by, w, color, alpha=1.0):
        dx, dy = bx - ax, by - ay
        ll = dx * dx + dy * dy

        def sdf(x, y):
            t = max(0.0, min(1.0, ((x - ax) * dx + (y - ay) * dy) / ll))
            return math.hypot(x - ax - t * dx, y - ay - t * dy) - w / 2

        self.shape(sdf, (min(ax, bx) - w, min(ay, by) - w,
                         max(ax, bx) + w, max(ay, by) + w), color, alpha)

    def save(self, path):
        raw = bytearray()
        for row in self.px:
            raw.append(0)
            for p in row:
                raw.extend(max(0, min(255, int(c * 255 + 0.5))) for c in p)

        def chunk(tag, data):
            c = struct.pack('>I', len(data)) + tag + data
            return c + struct.pack('>I', zlib.crc32(tag + data) & 0xffffffff)

        png = b'\x89PNG\r\n\x1a\n'
        png += chunk(b'IHDR', struct.pack('>IIBBBBB', W, H, 8, 2, 0, 0, 0))
        png += chunk(b'IDAT', zlib.compress(bytes(raw), 9))
        png += chunk(b'IEND', b'')
        with open(path, 'wb') as f:
            f.write(png)


def hackathon():
    c = Canvas('#1A237E', '#4A148C', diag=True)
    for i, (x, y, r) in enumerate([(90, 70, 40), (720, 90, 60), (680, 390, 35), (120, 380, 55)]):
        c.circle(x, y, r, '#7C4DFF', 0.25)
    c.rect(230, 100, 570, 320, '#263238', radius=14)
    c.rect(245, 115, 555, 305, '#0D1B2A', radius=6)
    lines = [(265, 140, 420, '#69F0AE'), (285, 165, 480, '#40C4FF'), (285, 190, 440, '#FFD740'),
             (305, 215, 510, '#40C4FF'), (305, 240, 470, '#FF80AB'), (285, 265, 400, '#69F0AE'),
             (265, 290, 330, '#FFD740')]
    for x0, y, x1, col in lines:
        c.line(x0, y, x1, y, 9, col)
    c.rect(190, 320, 610, 345, '#B0BEC5', radius=10)
    c.rect(360, 320, 440, 330, '#78909C', radius=4)
    return c


def ai_talk():
    c = Canvas('#004D40', '#00838F', diag=True)
    nodes = [(150, 120), (150, 225), (150, 330), (330, 90), (330, 190), (330, 280), (330, 370),
             (510, 140), (510, 240), (510, 330), (670, 225)]
    layers = [[0, 1, 2], [3, 4, 5, 6], [7, 8, 9], [10]]
    for a, b in zip(layers, layers[1:]):
        for i in a:
            for j in b:
                c.line(*nodes[i], *nodes[j], 3, '#B2DFDB', 0.55)
    for k, (x, y) in enumerate(nodes):
        c.circle(x, y, 24, '#E0F2F1')
        c.circle(x, y, 13, '#FFAB40' if k == 10 else '#26A69A')
    return c


def painting():
    c = Canvas('#FF7043', '#EC407A', diag=True)
    c.line(330, 70, 250, 400, 14, '#6D4C41')
    c.line(470, 70, 550, 400, 14, '#6D4C41')
    c.line(400, 60, 400, 400, 12, '#5D4037')
    c.rect(270, 90, 530, 280, '#FFF8E1', radius=6)
    c.circle(350, 170, 45, '#FFCA28')
    c.rect(300, 210, 500, 265, '#66BB6A', radius=20)
    c.circle(450, 150, 28, '#42A5F5')
    c.rect(255, 280, 545, 296, '#795548', radius=6)
    # palette
    c.circle(640, 360, 70, '#FFE0B2')
    c.circle(665, 385, 16, '#FF7043', 1.0)
    for x, y, col in [(610, 330, '#E53935'), (645, 315, '#FDD835'), (680, 335, '#1E88E5'), (605, 370, '#43A047')]:
        c.circle(x, y, 13, col)
    c.circle(665, 385, 15, '#EC407A')
    return c


def music():
    c = Canvas('#311B92', '#880E4F', diag=True)
    for i in range(5):
        y = 150 + i * 30
        c.line(60, y, 740, y, 3, '#F8BBD0', 0.6)
    notes = [(180, 255, '#FFD54F'), (300, 225, '#FFFFFF'), (420, 195, '#80DEEA'), (540, 240, '#FFD54F')]
    for x, y, col in notes:
        c.shape(lambda px, py, x=x, y=y: math.hypot((px - x) / 1.3, py - y) - 20,
                (x - 30, y - 22, x + 30, y + 22), col)
        c.line(x + 24, y, x + 24, y - 120, 7, col)
    c.line(204, 135, 324, 105, 14, '#FFD54F')
    c.line(444, 75, 564, 120, 14, '#80DEEA')
    for x, y, r in [(90, 380, 30), (700, 70, 45), (720, 390, 25)]:
        c.circle(x, y, r, '#F48FB1', 0.3)
    return c


def football():
    c = Canvas('#2E7D32', '#1B5E20')
    for i in range(0, 8):
        if i % 2 == 0:
            c.rect(i * 100, 0, i * 100 + 100, 450, '#388E3C', alpha=0.6)
    c.rect(40, 40, 760, 410, '#FFFFFF', alpha=0.0)
    for (ax, ay, bx, by) in [(40, 40, 760, 40), (40, 410, 760, 410), (40, 40, 40, 410),
                             (760, 40, 760, 410), (400, 40, 400, 410)]:
        c.line(ax, ay, bx, by, 6, '#FFFFFF', 0.9)
    c.ring(400, 225, 75, 6, '#FFFFFF', 0.9)
    for (ax, ay, bx, by) in [(40, 130, 150, 130), (150, 130, 150, 320), (40, 320, 150, 320),
                             (760, 130, 650, 130), (650, 130, 650, 320), (760, 320, 650, 320)]:
        c.line(ax, ay, bx, by, 6, '#FFFFFF', 0.9)
    c.circle(520, 290, 42, '#FAFAFA')
    for a in range(5):
        ang = a * 2 * math.pi / 5 - math.pi / 2
        c.circle(520 + 26 * math.cos(ang), 290 + 26 * math.sin(ang), 9, '#212121')
    c.circle(520, 290, 13, '#212121')
    return c


def running():
    c = Canvas('#FFB74D', '#E65100')
    c.circle(620, 130, 70, '#FFF3E0', 0.9)
    c.rect(0, 280, 800, 450, '#BF360C')
    for i in range(5):
        y = 300 + i * 32
        c.line(0, y, 800, y, 4, '#FFCCBC', 0.8)
    # finish line flags
    c.line(150, 120, 150, 300, 8, '#ECEFF1')
    c.line(650, 200, 650, 300, 8, '#ECEFF1')
    for k in range(10):
        c.rect(150 + k * 50, 120 + k * 8, 200 + k * 50, 150 + k * 8,
               '#212121' if k % 2 == 0 else '#FAFAFA')
    for x, s in [(300, 1.0), (470, 0.8)]:
        c.circle(x, 395 - 120 * s, 16 * s, '#3E2723')
        c.line(x, 410 - 120 * s, x - 10 * s, 455 - 120 * s, 12 * s, '#3E2723')
        c.line(x - 10 * s, 455 - 120 * s, x + 25 * s, 480 - 90 * s, 10 * s, '#3E2723')
        c.line(x - 10 * s, 455 - 120 * s, x - 40 * s, 475 - 95 * s, 10 * s, '#3E2723')
        c.line(x, 420 - 120 * s, x + 30 * s, 440 - 130 * s, 8 * s, '#3E2723')
        c.line(x, 420 - 120 * s, x - 30 * s, 445 - 115 * s, 8 * s, '#3E2723')
    return c


if __name__ == '__main__':
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    for name, fn in [('tech_hackathon', hackathon), ('tech_ai_talk', ai_talk),
                     ('arts_painting', painting), ('arts_music', music),
                     ('sports_football', football), ('sports_running', running)]:
        fn().save(os.path.join(out, name + '.png'))
        print('wrote', name)
