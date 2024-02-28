#!/bin/bash

# 设置环境变量
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/Cellar/switchaudio-osx/1.2.2:$PATH

# 获取全部音频设备的列表
available_devices=$(SwitchAudioSource -a -t input)

# 获取当前音频设备
current_device=$(SwitchAudioSource -c -t input)

# 查找当前设备在列表中的索引
current_index=-1
for i in "${!devices[@]}"; do
    if [ "${devices[i]}" == "$current_device" ]; then
        current_index=$i
        break
    fi
done

# 切换到下一个设备
next_index=$(( (current_index + 1) % ${#devices[@]} ))
next_device="${devices[next_index]}"

# 循环直到找到一个可用的设备
while true; do
    # 检查下一个设备是否在可用设备列表中
    if echo "$available_devices" | grep -q "$next_device"; then
        # 检查是否已经循环到了当前设备
        if [ "$next_device" != "$current_device" ]; then
            # 切换设备
            SwitchAudioSource -s "$next_device" -t input >/dev/null
            echo "已切换设备到 $next_device"
            break
        else
            echo "切换失败，暂无其他可用设备"
            break
        fi
    fi
    
    # 尝试下一个设备
    next_index=$(( (next_index + 1) % ${#devices[@]} ))
    next_device="${devices[next_index]}"
done