import psutil, GPUtil
from tabulate import tabulate


def get_size(bytes, suffix="B"):
    """
    Scale bytes to its proper format
    e.g:
        1253656 => '1.20MB'
        1253656678 => '1.17GB'
    """
    factor = 1024
    for unit in ["", "K", "M", "G", "T", "P"]:
        if bytes < factor:
            return f"{bytes:.2f}{unit}{suffix}"

        bytes /= factor


def cpu_info(view = False) -> dict:
    cpu_freq = psutil.cpu_freq()
    result = {
      "physical": psutil.cpu_count(logical=False),
      "logical": psutil.cpu_count(logical=True),
      "freq_max": cpu_freq.max,
      "freq_min": cpu_freq.min,
      "freq_current": cpu_freq.current,
      "percent": psutil.cpu_percent(),
    }

    if view:
        print (f"{'='*40} CPU Info {'='*40}\n"     \
        f"Physical cores: {result['physical']}\n"  \
        f"Total cores: {result['logical']}\n"      \
        f"Max Frequency: {result['freq_max']:.2f}MhzMhz\n"      \
        f"Min Frequency: {result['freq_min']:.2f}Mhz\n"         \
        f"Current Frequency: {result['freq_current']:.2f}Mhz\n" \
        f"Total CPU Usage: {result['percent']}%")

    return result


def mem_info(view = False) -> dict:
    result = {"memory": psutil.virtual_memory(), "swap": psutil.swap_memory()}

    if view:
        svmem, swap = result["memory"], result["swap"]

        print (f"{'='*40} Memory Info {'='*40}\n"   \
        f"Total: {get_size(svmem.total)}\n"         \
        f"Available: {get_size(svmem.available)}\n" \
        f"Used: {get_size(svmem.used)}\n"       \
        f"Percentage: {svmem.percent}%\n"       \
        f"Swap Total: {get_size(swap.total)}\n" \
        f"Swap Free: {get_size(swap.free)}\n"   \
        f"Swap Used: {get_size(swap.used)}\n"   \
        f"Swap Percentage: {swap.percent}%")

    return result


def gpu_info(view=False) -> list:
    gpus = GPUtil.getGPUs()
    list_gpus = [
      ["id", "name", "load", "free memory", "used memory", "total memory", "temperature", "uuid"]
    ]

    for gpu in gpus:
        gpu_id = gpu.id
        gpu_name = gpu.name
        gpu_load = f"{gpu.load*100}%"
        gpu_free_memory = f"{gpu.memoryFree}MB"
        gpu_used_memory = f"{gpu.memoryUsed}MB"
        gpu_total_memory = f"{gpu.memoryTotal}MB"
        gpu_temperature = f"{gpu.temperature} °C"
        gpu_uuid = gpu.uuid

        list_gpus.append((
          gpu_id, gpu_name, gpu_load, gpu_free_memory, gpu_used_memory,
          gpu_total_memory, gpu_temperature, gpu_uuid
        ))

    if view:
        text = f"{'='*40} GPU Details {'='*40}\n"
        print(text + tabulate(list_gpus[1:], headers=list_gpus[0]))

    return list_gpus


if __name__ == '__main__':
    cpu_info(True)
    mem_info(True)
    gpu_info(True)
