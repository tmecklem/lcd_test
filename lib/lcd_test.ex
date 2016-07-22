defmodule LcdTest do
  def start(_type, _args) do
    {:ok, lcd_pid} = ElixirLcd.I2cExpander.connect("i2c-1", 0x27)

    ElixirLcd.Lcd.reset_4_bits
    |> ElixirLcd.I2cExpander.execute(lcd_pid)

    'Hello'
    |> ElixirLcd.Lcd.display_chars
    |> ElixirLcd.I2cExpander.execute(lcd_pid)

    keypad_pid = spawn(CharacterKeypad, :start_link, [])

    keymap =  [
      '123A',
      '456B',
      '789C',
      '*0#D'
    ]
    send keypad_pid, { self, keymap, "i2c-1", 0x20 }
    loop(lcd_pid)
  end

  def loop(lcd_pid) do
    receive do
      { :keydown, pressed_keys } ->
        pressed_keys
        |> ElixirLcd.Lcd.display_chars
        |> ElixirLcd.I2cExpander.execute(lcd_pid)
        loop(lcd_pid)
    end
  end
end
