
class Configuration(object):

    weight_dtype = 'f8'

    window_title = 'Hopfield Simulation'

    window_size = 800, 400

    max_size = 150

configuration = Configuration()

class Settings(Configuration):

    size = (75,75)

    match_percent = 99.9

    image_lib_dir = './images'

    flipped_noise = False

    async_speed = 200

    synchronous = False

    temperature = None

    stop_percentage = None



settings = Settings()