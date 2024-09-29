import { LitElement, html, PropertyValues } from 'lit';
import { customElement, property, state } from 'lit/decorators.js';
import { classMap } from 'lit/directives/class-map.js';
import { styleMap } from 'lit/directives/style-map.js';
import interact from 'interactjs';

@customElement('pomodoro-timer')
export class PomodoroTimer extends LitElement {
    protected createRenderRoot(): HTMLElement | DocumentFragment {
        return this;
    }

    @property({ type: Number }) _timer: number = 1500;

    @state() private _intervalId: number | null = null;

    @state() private _isRunning: boolean = false;
    @state() private _isMinimized: boolean = false;

    private _posX: number = 0;
    private _posY: number = 0;

    render() {
        const classes = {
            'bg-body': this._timer !== 0,
            'bg-info': this._timer === 0,
            'rounded': !this._isMinimized,
            'rounded-circle': this._isMinimized,
        };

        const styles = {
            top: `${this._posY}px`,
            left: `${this._posX}px`,
            width: this._isMinimized ? '4rem' : '20rem',
            height: this._isMinimized ? '4rem' : 'auto',
        };

        return html`
            <div class="border position-absolute p-3 shadow ${classMap(classes)}" style="${styleMap(styles)}">
                ${this._isMinimized
                ? html`
                        <div class="d-flex justify-content-center align-items-center h-100 w-100 fs-3" @click=${this._toggleMinimize}>
                                🍅
                        </div>`
                : html`
                        <div>
                            <button class="btn btn-sm btn-secondary float-end" @click=${this._toggleMinimize}>Minimize</button>
                            <h3 class="fs-3">🍅</h3>
                            <hr />
                            <pre class="fs-1 text-center">${this._formatTime(this._timer)}</pre>
                            <hr />
                            <div class="d-flex gap-1 justify-content-end">
                                <button class="btn btn-primary" @click=${this._start} ?disabled=${this._isRunning}>Start</button>
                                <button class="btn btn-danger" @click=${this._stop} ?disabled=${!this._isRunning}>Stop</button>
                                <button class="btn btn-secondary" @click=${this._reset}>Reset</button>
                            </div>
                        </div>
                    `}
            </div>
        `;
    }

    private _start() {
        if (!this._intervalId) {
            this._isRunning = true;
            this._saveState();

            this._intervalId = window.setInterval(() => {
                if (this._timer > 0) {
                    --this._timer;
                    this._saveState();
                    return;
                }

                this._stop();
            }, 1000);
        }
    }

    private _stop() {
        if (this._intervalId) {
            clearInterval(this._intervalId);
            this._intervalId = null;
            this._isRunning = false;
            this._saveState();
        }
    }

    private _reset() {
        this._stop();
        this._timer = 1500;
        this._isRunning = false;
        this._saveState();
    }

    private _formatTime(seconds: number): string {
        const minutes = Math.floor(seconds / 60);
        const remainingSeconds = seconds % 60;
        return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
    }

    private _toggleMinimize() {
        this._isMinimized = !this._isMinimized;
        this._saveState();
    }

    private _saveState() {
        const state = {
            timer: this._timer,
            posX: this._posX,
            posY: this._posY,
            isMinimized: this._isMinimized,
            isRunning: this._isRunning,
        };
        localStorage.setItem('pomodoro-state', JSON.stringify(state));
    }

    protected firstUpdated(_changedProperties: PropertyValues): void {
        const savedState = localStorage.getItem('pomodoro-state');
        if (savedState) {
            const { timer, posX, posY, isMinimized, isRunning } = JSON.parse(savedState);
            this._timer = timer;
            this._posX = posX;
            this._posY = posY;
            this._isMinimized = isMinimized;
            this._isRunning = isRunning;

            if (this._isRunning) {
                this._start();
            }

            this.requestUpdate();
        }

        const draggableElement = this.querySelector('div');
        if (!draggableElement) {
            return;
        }

        interact(draggableElement).draggable({
            listeners: {
                move: (event) => {
                    this._posX += event.dx;
                    this._posY += event.dy;

                    this.requestUpdate();

                    this._saveState();
                },
            },
            inertia: true,
            modifiers: [
                interact.modifiers.restrictRect({
                    restriction: 'body',
                    endOnly: true,
                }),
            ],
        });
    }
}

declare global {
    interface HTMLElementTagNameMap {
        'pomodoro-timer': PomodoroTimer;
    }
}
