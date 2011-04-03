/* See LICENSE file for copyright and license details. */
/* © 2010 joten <joten@freenet.de> */

struct Monitor {
	char ltsymbol[16];
	float mfact;
	double mfacts[LENGTH(tags) + 1];
	int ltaxis[3];
	int ltaxes[LENGTH(tags) + 1][3];
	int num;
	int curtag;
	int prevtag;
	int by;               /* bar geometry */
	int mx, my, mw, mh;   /* screen size */
	int wx, wy, ww, wh;   /* window area  */
	unsigned int msplit;
	unsigned int msplits[LENGTH(tags) + 1];
	unsigned int seltags;
	unsigned int sellt;
	unsigned int tagset[2];
	Bool showbar;
	Bool showbars[LENGTH(tags) + 1];
	Bool topbar;
	Client *clients;
	Client *sel;
	Client *stack;
	Monitor *next;
	Window barwin;
	const Layout *lt[2];
	const Layout *lts[LENGTH(tags) + 1];
};

/* function declarations */
static void mirrorlayout(const Arg *arg);
static void rotatelayoutaxis(const Arg *arg);
static void shiftmastersplit(const Arg *arg);

void
mirrorlayout(const Arg *arg) {
	if(!selmon->lt[selmon->sellt]->arrange)
		return;
	selmon->ltaxis[0] *= -1;
	selmon->ltaxes[selmon->curtag][0] = selmon->ltaxis[0];
	arrange(selmon);
}

void
rotatelayoutaxis(const Arg *arg) {
	if(!selmon->lt[selmon->sellt]->arrange)
		return;
	if(arg->i == 0) {
		if(selmon->ltaxis[0] > 0)
			selmon->ltaxis[0] = selmon->ltaxis[0] + 1 > 2 ? 1 : selmon->ltaxis[0] + 1;
		else
			selmon->ltaxis[0] = selmon->ltaxis[0] - 1 < -2 ? -1 : selmon->ltaxis[0] - 1;
	} else
		selmon->ltaxis[arg->i] = selmon->ltaxis[arg->i] + 1 > 3 ? 1 : selmon->ltaxis[arg->i] + 1;
	selmon->ltaxes[selmon->curtag][arg->i] = selmon->ltaxis[arg->i];
	arrange(selmon);
}

void
shiftmastersplit(const Arg *arg) {
	unsigned int n;
	Client *c;

	for(n = 0, c = nexttiled(selmon->clients); c; c = nexttiled(c->next), n++);
	if(!arg || !selmon->lt[selmon->sellt]->arrange || selmon->msplit + arg->i < 1 || selmon->msplit + arg->i > n)
		return;
	selmon->msplit += arg->i;
	selmon->msplits[selmon->curtag] = selmon->msplit;
	arrange(selmon);
}

void
tile(Monitor *m) {
	char sym1 = 61, sym2 = 93, sym3 = 61, sym;
	int x1 = m->wx, y1 = m->wy, h1 = m->wh, w1 = m->ww, X1 = x1 + w1, Y1 = y1 + h1;
	int x2 = m->wx, y2 = m->wy, h2 = m->wh, w2 = m->ww, X2 = x2 + w2, Y2 = y2 + h2;
	unsigned int i, n, n1, n2;
	Client *c;

	for(n = 0, c = nexttiled(m->clients); c; c = nexttiled(c->next), n++);
	if(m->msplit > n)
		m->msplit = (n == 0) ? 1 : n;
	/* layout symbol */
	if(abs(m->ltaxis[0]) == m->ltaxis[1])    /* explicitly: ((abs(m->ltaxis[0]) == 1 && m->ltaxis[1] == 1) || (abs(m->ltaxis[0]) == 2 && m->ltaxis[1] == 2)) */
		sym1 = 124;
	if(abs(m->ltaxis[0]) == m->ltaxis[2])
		sym3 = 124;
	if(m->ltaxis[1] == 3)
		sym1 = (n == 0) ? 0 : m->msplit;
	if(m->ltaxis[2] == 3)
		sym3 = (n == 0) ? 0 : n - m->msplit;
	if(m->ltaxis[0] < 0) {
		sym = sym1;
		sym1 = sym3;
		sym2 = 91;
		sym3 = sym;
	}
	if(m->msplit == 1) {
		if(m->ltaxis[0] > 0)
			sym1 = 91;
		else
			sym3 = 93;
	}
	if(m->msplit > 1 && m->ltaxis[1] == 3 && m->ltaxis[2] == 3)
		snprintf(m->ltsymbol, sizeof m->ltsymbol, "%d%c%d", sym1, sym2, sym3);
	else if((m->msplit > 1 && m->ltaxis[1] == 3 && m->ltaxis[0] > 0) || (m->ltaxis[2] == 3 && m->ltaxis[0] < 0))
		snprintf(m->ltsymbol, sizeof m->ltsymbol, "%d%c%c", sym1, sym2, sym3);
	else if((m->ltaxis[2] == 3 && m->ltaxis[0] > 0) || (m->msplit > 1 && m->ltaxis[1] == 3 && m->ltaxis[0] < 0))
		snprintf(m->ltsymbol, sizeof m->ltsymbol, "%c%c%d", sym1, sym2, sym3);
	else
		snprintf(m->ltsymbol, sizeof m->ltsymbol, "%c%c%c", sym1, sym2, sym3);
	if(n == 0)
		return;
	/* master and stack area */
	if(abs(m->ltaxis[0]) == 1 && n > m->msplit) {
		w1 *= m->mfact;
		w2 -= w1;
		x1 += (m->ltaxis[0] < 0) ? w2 : 0;
		x2 += (m->ltaxis[0] < 0) ? 0 : w1;
		X1 = x1 + w1;
		X2 = x2 + w2;
	} else if(abs(m->ltaxis[0]) == 2 && n > m->msplit) {
		h1 *= m->mfact;
		h2 -= h1;
		y1 += (m->ltaxis[0] < 0) ? h2 : 0;
		y2 += (m->ltaxis[0] < 0) ? 0 : h1;
		Y1 = y1 + h1;
		Y2 = y2 + h2;
	}
	/* master */
	n1 = (m->ltaxis[1] != 1 || w1 / m->msplit < bh) ? 1 : m->msplit;
	n2 = (m->ltaxis[1] != 2 || h1 / m->msplit < bh) ? 1 : m->msplit;
	for(i = 0, c = nexttiled(m->clients); i < m->msplit; c = nexttiled(c->next), i++) {
		resize(c, x1, y1, 
			(m->ltaxis[1] == 1 && i + 1 == m->msplit) ? X1 - x1 - 2 * c->bw : w1 / n1 - 2 * c->bw, 
			(m->ltaxis[1] == 2 && i + 1 == m->msplit) ? Y1 - y1 - 2 * c->bw : h1 / n2 - 2 * c->bw, False);
		if(n1 > 1)
			x1 = c->x + WIDTH(c);
		if(n2 > 1)
			y1 = c->y + HEIGHT(c);
	}
	/* stack */
	if(n > m->msplit) {
		n1 = (m->ltaxis[2] != 1 || w2 / (n - m->msplit) < bh) ? 1 : n - m->msplit;
		n2 = (m->ltaxis[2] != 2 || h2 / (n - m->msplit) < bh) ? 1 : n - m->msplit;
		for(i = 0; c; c = nexttiled(c->next), i++) {
			resize(c, x2, y2, 
				(m->ltaxis[2] == 1 && i + 1 == n - m->msplit) ? X2 - x2 - 2 * c->bw : w2 / n1 - 2 * c->bw, 
				(m->ltaxis[2] == 2 && i + 1 == n - m->msplit) ? Y2 - y2 - 2 * c->bw : h2 / n2 - 2 * c->bw, False);
			if(n1 > 1)
				x2 = c->x + WIDTH(c);
			if(n2 > 1)
				y2 = c->y + HEIGHT(c);
		}
	}
}
