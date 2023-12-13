import pyautogui
import keyboard

def simulate_mouse_wheel(direction):
    if direction == "up":
        pyautogui.scroll(1)  # Scroll up
    elif direction == "down":
        pyautogui.scroll(-1)  # Scroll down

def on_key_event(e):
    if e.event_type == keyboard.KEY_UP:
        if e.name == "page up":
            simulate_mouse_wheel("up")
        elif e.name == "page down":
            simulate_mouse_wheel("down")

keyboard.hook(on_key_event)

# Program berjalan dalam loop untuk mendengarkan input keyboard
# keyboard.wait("del")  # Tekan tombol Esc untuk keluar dari program
