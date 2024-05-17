import { useNavigate } from 'react-router-dom';
import { useEffect, useState } from 'react';

import Clock from './HomeClockComponent.jsx'
import Calendar from './CalendarWidget.jsx'
import TodoList from './HomeTodoListComponent.jsx'
import Schedule from './HomeScheduleComponent.jsx'
import MozzyModal from '../mozzy/MozzyMainPage..jsx'
import LongSitModal from '../mozzy/MozzyLongSitPage.jsx'

import testImg1 from './test/swiper-slide-test-img-1.png'
import testImg2 from './test/swiper-slide-test-img-2.jpg'
import Mozzy from '../../assets/Mozzy.svg'
import { Swiper, SwiperSlide } from 'swiper/react';

// Import Swiper styles
import 'swiper/css';
import 'swiper/css/pagination';

import { Pagination } from 'swiper/modules';
import AuthStore from '../../stores/AuthStore.js';
import { getCurrentUser } from '../../services/jiraService.js'

export default function HomePage() {
    const [modalIsOpen, setModalIsOpen] = useState(false);
    const [longSitModalIsOpen, setLongSitModalIsOpen] = useState(false);
    const navigate = useNavigate();
    const { checkStoredAuth, isAuthenticated } = AuthStore((state) => ({
        checkStoredAuth: state.checkStoredAuth,
        isAuthenticated: state.isAuthenticated
    }))

    const openModal = () => {
        setModalIsOpen(true);
    };

    const closeModal = () => {
        setModalIsOpen(false);
    };

    const openLongSitModal = () => {
        setLongSitModalIsOpen(true);
    };

    const closeLongSitModal = () => {
        setLongSitModalIsOpen(false);
    };

    const callAlertFunction = () => {  // 개발용
        navigate(`/callalert`);
    };

    useEffect(() => {
        console.log('홈에서 확인중')
        checkStoredAuth()
        getCurrentUser()
      }, [])
    
    useEffect(() => {
        // Electron에서 'motion-detected' 메시지를 수신
        window.electron.ipcRenderer.on('motion-detected', (event, data) => {
            console.log('status data: ', data.status)
            if (data.status === 'LONG_SIT') {
                openLongSitModal();
            }
        });

        // 컴포넌트 언마운트 시 이벤트 리스너 제거
        return () => {
            window.electron.ipcRenderer.removeAllListeners('motion-detected');
        };
    }, []);

    useEffect(() => {
        const { accessToken, refreshToken } = AuthStore.getState()
        console.log('AccessToken:', accessToken)
        console.log('RefreshToken:', refreshToken)
        if (!accessToken) {
            navigate('/login')
        }
    }, [])


    return (
        <div className=" mx-auto p-4 h-screen">
            {/* 전체 레이아웃을 3열로 분할하고, 각 열을 화면 높이와 동일하게 설정 */}
            <div className="grid grid-cols-[0.5fr,2.5fr,1fr] gap-8 h-full">
                {/* 1열: 시계, 달력 위아래로 배치 */}
                <div className="ml-1 flex flex-col space-y-8 gap-8">
                    <div onClick={() => callAlertFunction()}>
                        <Clock />
                    </div>
                    <div className="flex h-80 w-56 justify-center ml-3" >
                        <Swiper
                            style={{
                                "--swiper-theme-color": "#6ECEF5", /* 선택된 동그란 바의 색상 */
                                "--swiper-pagination-bullet-inactive-color": "#FFFFFF", /* 선택되지 않은 동그란 바의 색상 */
                                "--swiper-pagination-bullet-width": "12px",
                                "--swiper-pagination-bullet-height": "12px",
                                display: 'flex',
                                flexDirection: 'column'
                            }}
                            pagination={{
                                dynamicBullets: true,
                            }}
                            modules={[Pagination]}
                            className="mySwiper"
                        >
                            <SwiperSlide style={{ display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', marginBottom: '2.5rem' }}><Calendar /></SwiperSlide>
                            <SwiperSlide style={{ display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', marginBottom: '2.5rem' }}><img src={testImg1} alt="테스트이미지1" className="mb-14 rounded-md" /></SwiperSlide>
                            <SwiperSlide style={{ display: 'flex', flexDirection: 'column', justifyContent: 'flex-end', marginBottom: '2.5rem' }}><img src={testImg2} alt="테스트이미지2" className="mb-14 rounded-md" /></SwiperSlide>
                        </Swiper>
                    </div>
                </div>
                {/* 2열: 스케줄러만 중앙에 */}
                <div className="flex flex-col justify-center">
                    <Schedule />
                </div>
                {/* 3열: 할 일 목록, 모찌 위아래로 배치 */}
                <div className="flex flex-col justify-between items-end mr-8 h-full">
                    <div className="mt-4">
                    <TodoList />
                    </div>
                    <div className="mt-6">
                        <img src={Mozzy} alt="Mozzy" className="size-60" onClick={openModal} />
                        <MozzyModal isOpen={modalIsOpen} onClose={closeModal}/>
                        <LongSitModal isOpen={longSitModalIsOpen} onClose={closeLongSitModal} />
                    </div>
                </div>
            </div>
        </div>
    );
}