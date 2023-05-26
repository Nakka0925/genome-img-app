import subprocess

def start_rails():
    subprocess.run('rails server', shell=True)

def start_flask():
    subprocess.run('cd lib/train_api && python crud.py', shell=True)

if __name__ == '__main__':
    import multiprocessing

    rails_process = multiprocessing.Process(target=start_rails)
    flask_process = multiprocessing.Process(target=start_flask)

    rails_process.start()
    flask_process.start()

    rails_process.join()
    flask_process.join()

